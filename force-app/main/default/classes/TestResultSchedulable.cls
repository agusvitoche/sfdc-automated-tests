/**
 * @description       : Schedulable to send apex test execution resume
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 03-27-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class TestResultSchedulable implements Database.Batchable<sObject>, Schedulable, Database.Stateful, Database.AllowsCallouts {
    
    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-27-2022 
    * @param sc 
    **/
    global void execute(SchedulableContext sc) {
        System.debug('TestResultSchedulable - execute - START');
        Database.executeBatch(new TestResultSchedulable(), 1);
        System.debug('TestResultSchedulable - execute - END');
    }
    
    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-27-2022 
    * @param BC 
    * @return Database.QueryLocator 
    **/
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String strQuery = 'SELECT Id, Status FROM AsyncApexJob WHERE JobType = \'TestRequest\' AND ApexClass.Name = \'AssignPermissionSetTest\' ORDER BY CreatedDate DESC LIMIT 1';
        return Database.getQueryLocator(strQuery);
    }
    
    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-27-2022 
    * @param BC 
    * @param scope 
    **/
    global void execute(Database.BatchableContext BC, List<AsyncApexJob> scope) {
        System.debug('TestResultSchedulable - execute - START');
        
        Id lastTestExecution = AutomatedTesting.getLastTestExecution();
        System.debug('TestResultSchedulable - execute - lastTestExecution: ' + lastTestExecution);
        
        AutomatedTesting.emailTestStatus(lastTestExecution);
        
        System.debug('TestResultSchedulable - execute - END');
    }
    
    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-27-2022 
    * @param BC 
    **/
    global void finish(Database.BatchableContext BC) {
        // Do nothing
    }

}
