/**
 * @description       : Helper to execute apex test methods and send email resume
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 03-27-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class AutomatedTesting {
    
    /**
     * Set your apex classes that has 'test' in its name
     * TODO: Move to CMT
     */
    private static String[] EXCLUDED_CLASSES = new String[] {};

    /**
     * Email addresses to send email resume
     * TODO: Move to CMT
     */
    private static String[] NOTIFICATION_EMAILS = new String[] {};

    
    /**
    * @description Start apex test execution
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-27-2022 
    * @return Id Apex test execution job id
    **/
    public static Id enqueueTests() {
        System.debug('AutomatedTesting - enqueueTests - START');

        // Get all classes with 'test' in its name
        // TODO: A better way to get only test classes??
        List<ApexClass> testClasses = [SELECT Id, Name
                                       FROM ApexClass
                                       WHERE Name LIKE '%Test%'
                                       AND Name NOT IN :EXCLUDED_CLASSES
                                       AND NameSpacePrefix = null 
                                       ORDER BY Name];
        System.debug('AutomatedTesting - enqueueTests - testClasses: ' + testClasses.size());

        Id jobId = null;

        if (!testClasses.isEmpty()) {

            ApexTestQueueItem[] queueItems = new List<ApexTestQueueItem>();
            for (ApexClass classIterator : testClasses) {
                System.debug('AutomatedTesting - enqueueTests - classIterator: ' + classIterator.Name);
                queueItems.add(new ApexTestQueueItem(ApexClassId = classIterator.Id));
            }
            System.debug('AutomatedTesting - enqueueTests - queueItems: ' + queueItems);

            if (!Test.isRunningTest()) {

                System.debug('AutomatedTesting - enqueueTests - INSERT: ' + queueItems.size());
                insert queueItems;

                // Get the job ID of the first queue item returned.
                List<ApexTestQueueItem> enqueueItems = [SELECT ParentJobId FROM ApexTestQueueItem WHERE Id = :queueItems[0].Id];
                System.debug('AutomatedTesting - enqueueTests - enqueueItems: ' + enqueueItems.size());

                jobId = enqueueItems.get(0).ParentJobId;
            }
        }

        System.debug('AutomatedTesting - enqueueTests - END: ' + jobId);
        return jobId;
    }
    
    /**
    * @description Send email with apex test execution resume
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-27-2022 
    * @param jobId Apex test execution job id
    * @return Messaging.SingleEmailMessage Email sended
    **/
    public static Messaging.SingleEmailMessage emailTestStatus(Id jobId) {
        System.debug('AutomatedTesting - emailTestStatus - START: ' + jobId);

        List<ApexTestResult> testResults = [SELECT AsyncApexJobId, Outcome, ApexClass.Name, MethodName, Message, StackTrace 
                                            FROM ApexTestResult 
                                            WHERE AsyncApexJobId = :jobId
                                            ORDER BY ApexClass.Name];
        System.debug('AutomatedTesting - emailTestStatus - testResults: ' + testResults.size());

        Integer totalTests = 0;
        Integer testPassed = 0;
        Integer testError = 0;

        String currentClass = '';
        String failedTable = '<table border="1" cellpading="5px">';

        for (ApexTestResult resultIterator : testResults) {
            System.debug('AutomatedTesting - emailTestStatus - resultIterator: ' + resultIterator);

            if (resultIterator.OutCome != 'Pass') { //TODO-CONS
                if (resultIterator.ApexClass.Name != currentClass) {
                    System.debug('AutomatedTesting - emailTestStatus - ApexClass ERROR: ' + resultIterator.ApexClass.Name);
                    currentClass = resultIterator.ApexClass.Name;
                    failedTable += '<tr style="background: #ddd; font-weight: bold;"><td colspan="2">' + currentClass + '</td></tr>\n';
                }
                failedTable += '<tr><td>' + resultIterator.MethodName + '</td><td> ' + resultIterator.Message + '</td></tr>\n';
                testError++;
            }
        }
        totalTests = testResults.size();
        testPassed = totalTests - testError;
        failedTable += '</table>';
        System.debug('AutomatedTesting - emailTestStatus - totalTests: ' + totalTests);
        System.debug('AutomatedTesting - emailTestStatus - testPassed: ' + testPassed);
        System.debug('AutomatedTesting - emailTestStatus - testPassed: ' + testError);
        System.debug('AutomatedTesting - emailTestStatus - failedTable: ' + failedTable);

        currentClass = '';
        Decimal sumCoverage = 0;
        String coverageTable = '<table border="1" cellpading="5px">';
        Map<String, Decimal> codeCoverageByClass = getCodeCoverageByClass();

        for(String classIterator : codeCoverageByClass.keySet()) {
            if (classIterator != currentClass) {
                currentClass = classIterator;
                coverageTable += '<tr style="background: #ddd; font-weight: bold;"><td colspan="2">' + currentClass + '</td></tr>\n';
            }
            coverageTable += '<tr><td>' + classIterator + '</td><td> ' + codeCoverageByClass.get(classIterator).setScale(2) + '% </td></tr>\n';
            sumCoverage += codeCoverageByClass.get(classIterator);
        }
        coverageTable += '</table>';
        System.debug('AutomatedTesting - emailTestStatus - coverageTable: ' + coverageTable);

        Decimal orgCoverage = sumCoverage / codeCoverageByClass.keySet().size();
        System.debug('AutomatedTesting - emailTestStatus - orgCoverage: ' + orgCoverage);

        String emailBody = '<h2>Automated Tests Results</h2>'; //TODOLABEL
        emailBody += '<p>General Information</p>'; //TODOLABEL
        emailBody += '<ul>';
        emailBody += '<li>Org Code Coverage: ' + orgCoverage.setScale(2) + '% </li>'; //TODOLABEL
        emailBody += '<li>Methods: ' + testPassed + '/' + totalTests + ' passed</li>'; //TODOLABEL
        emailBody += '</ul>';

        Boolean allPassed = testPassed == totalTests;
        System.debug('AutomatedTesting - emailTestStatus - allPassed: ' + allPassed);

        if (!allPassed) {
            emailBody += '<h3>Test Failures:</h3>\n' + failedTable; //TODOLABEL
        }

        emailBody += '<h3>Code Coverage:</h3>\n' + coverageTable; //TODOLABEL
        System.debug('AutomatedTesting - emailTestStatus - emailBody: ' + emailBody);

        List<Messaging.SingleEmailMessage> listMessages = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage statusMail = new Messaging.SingleEmailMessage();
        statusMail.setToAddresses(NOTIFICATION_EMAILS);
        statusMail.setSubject('Automated Test Results: ' + (testPassed < totalTests ? 'Fail' : 'Pass'));
        statusMail.setHtmlBody(emailBody);
        System.debug('AutomatedTesting - emailTestStatus - statusMail: ' + statusMail);
        listMessages.add(statusMail);

        if (!Test.isRunningTest()) {
        	Messaging.sendEmail(listMessages);
		}

        System.debug('AutomatedTesting - emailTestStatus - END: ' + statusMail);
        return statusMail;
    }

    /**
    * @description Get percent code coverage for each class
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-27-2022 
    * @return Map<String, Decimal> Percent code coverage for each class
    **/
    public static Map<String, Decimal> getCodeCoverageByClass() {
        System.debug('AutomatedTesting - getCodeCoverageByClass - START');

        String queryStr = 'SELECT+NumLinesCovered,ApexClassOrTriggerId,ApexClassOrTrigger.Name,NumLinesUncovered,Coverage+FROM+ApexCodeCoverageAggregate+ORDER+BY+ApexClassOrTrigger.Name';
        System.debug('AutomatedTesting - getCodeCoverageByClass - queryStr: ' + queryStr);

        HTTPResponse res = toolingApiRequest(queryStr);
        System.debug('AutomatedTesting - getCodeCoverageByClass - res: ' + res.getBody());

        Map<String, Decimal> codeCoverageByClass = new Map<String, Decimal>();
        if (res.getStatusCode() == 200) {
            CodeCoverageWrapper codeCoverageWrapper = CodeCoverageWrapper.parse(res.getBody());

            for(CodeCoverageWrapper.Records records : codeCoverageWrapper.records) {
                
                String classOrTriggerName = records.apexClassOrTrigger.Name;
                System.debug('AutomatedTesting - getCodeCoverageByClass - classOrTriggerName: ' + classOrTriggerName);
                Decimal numLinesCovered = records.numLinesCovered;
                System.debug('AutomatedTesting - getCodeCoverageByClass - numLinesCovered: ' + numLinesCovered);
                Decimal numLinesUncovered = records.numLinesUncovered;
                System.debug('AutomatedTesting - getCodeCoverageByClass - numLinesUncovered: ' + numLinesUncovered);
                Decimal totalNumberOfLines = numLinesCovered + numLinesUncovered;
                System.debug('AutomatedTesting - getCodeCoverageByClass - totalNumberOfLines: ' + totalNumberOfLines);

                if(totalNumberOfLines == 0) continue;

                Decimal coveragePercentage = (numLinesCovered / totalNumberOfLines) * 100;
                System.debug('AutomatedTesting - getCodeCoverageByClass - coveragePercentage: ' + coveragePercentage);

                codeCoverageByClass.put(classOrTriggerName, coveragePercentage);
            }
        }

        codeCoverageByClass = sortCodeCoverageMapByCoverage(codeCoverageByClass);

        System.debug('AutomatedTesting - getCodeCoverageByClass - END: ' + codeCoverageByClass);
        return codeCoverageByClass;
    }

    /**
    * @description Sort classes from highest to lowest percent code coverage
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-27-2022 
    * @param coverageMap Percent code coverage for each class
    * @return Map<String, Decimal> Percent code coverage for each class sorted from highest to lowest
    **/
    public static Map<String, Decimal> sortCodeCoverageMapByCoverage(Map<String, Decimal> coverageMap) {
        System.debug('AutomatedTesting - sortCodeCoverageMapByCoverage - START');

        List<CodeCoverageWrapper.CoverageWrapper> listCoverage = new List<CodeCoverageWrapper.CoverageWrapper>();
        for(String classIterator : coverageMap.keySet()) {
            listCoverage.add(new CodeCoverageWrapper.CoverageWrapper(classIterator, coverageMap.get(classIterator)));
        }
        listCoverage.sort();

        List<CodeCoverageWrapper.CoverageWrapper> finalList = new List<CodeCoverageWrapper.CoverageWrapper>();
        for(Integer i = listCoverage.size() -1; i >= 0; i = i-1 ) {
            finalList.add(listCoverage.get(i));
        }

        Map<String,Decimal> coverageToNameMap = new Map<String,Decimal>();
        for(CodeCoverageWrapper.CoverageWrapper coverageIterator : finalList) {
            coverageToNameMap.put(coverageIterator.getObjectName(), coverageIterator.getValue());
        }

        System.debug('AutomatedTesting - sortCodeCoverageMapByCoverage - END');
        return coverageToNameMap;
    }

    /**
    * @description Get last apex test execution job id
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-27-2022 
    * @return Id Last apex test execution job id
    **/
    public static Id getLastTestExecution() {
        System.debug('AutomatedTesting - getLastTestExecution - START');

        List<AsyncApexJob> listExecutions = [SELECT Id, Status
                                             FROM AsyncApexJob
                                             WHERE JobType = 'TestRequest' 
                                             AND ApexClass.Name = 'AssignPermissionSetTest' 
                                             ORDER BY CreatedDate DESC
                                             LIMIT 1];
        System.debug('AutomatedTesting - toolingApiRequest - listExecutions: ' + listExecutions.size());
        
        Id jobId = null;
        if (!listExecutions.isEmpty()) {
            if (listExecutions.get(0).Status == 'Completed' || listExecutions.get(0).Status == 'Failed') { //TODOCONST
                jobId = listExecutions.get(0).Id;
            }
        }

        System.debug('AutomatedTesting - getLastTestExecution - END: ' + jobId);
        return jobId;
    }

    /**
    * @description Make a tooling api request
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-27-2022 
    * @param strQuery Query for tooling api request
    * @return HTTPResponse Request made it
    **/
    @TestVisible
    private static HTTPResponse toolingApiRequest(String strQuery) {
        System.debug('AutomatedTesting - toolingApiRequest - START: ' + strQuery);

        String endpoint = 'https://' + System.URL.getSalesforceBaseUrl().getHost() + '/services/data/v40.0/tooling/';
        System.debug('AutomatedTesting - toolingApiRequest - endpoint: ' + endpoint);

        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint + 'query/?q=' + strQuery);
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('GET');
        req.setTimeout(80000);
        System.debug('AutomatedTesting - toolingApiRequest - req: ' + req);

        Http http = new Http();
        HTTPResponse res = http.send(req);

        System.debug('AutomatedTesting - toolingApiRequest - END: ' + res);
        return res;
    }

}
