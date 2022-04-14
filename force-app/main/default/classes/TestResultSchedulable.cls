/**
 * @description       : Send tests execution email result
 * @author            : Agustín M. Etcheverry
 * @last modified on  : 04-15-2022
 * @last modified by  : Agustín M. Etcheverry
**/
global with sharing class TestResultSchedulable implements Database.Batchable<sObject>, Schedulable, Database.Stateful, Database.AllowsCallouts {
    
    global void execute(SchedulableContext sc) {
        System.debug('TestResultSchedulable - execute - START');
        Database.executeBatch(new TestResultSchedulable(), 1);
        System.debug('TestResultSchedulable - execute - END');
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String strQuery = 'SELECT Id, Status FROM AsyncApexJob WHERE JobType = \'TestRequest\' AND ApexClass.Name = \'AssignPermissionSetTest\' ORDER BY CreatedDate DESC LIMIT 1';
        return Database.getQueryLocator(strQuery);
    }
    
    global void execute(Database.BatchableContext BC, List<AsyncApexJob> scope) {
        System.debug('TestResultSchedulable - execute - START');
        
        Id lastTestExecution = AutomatedTesting.getLastTestExecution();
        System.debug('TestResultSchedulable - execute - lastTestExecution: ' + lastTestExecution);
        
        AutomatedTesting.emailTestStatus(lastTestExecution);
        
        System.debug('TestResultSchedulable - execute - END');
    }
    
    global void finish(Database.BatchableContext BC) {
        // Do Nothing
    }

}
