/**
 * @description       : Schedulable to run apex test execution
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 03-27-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class RunTestSchedulable {
    
    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-27-2022 
    * @param sc 
    **/
    global void execute(SchedulableContext sc) {
        System.debug('RunTestSchedulable - execute - START');
        Id jobId = AutomatedTesting.enqueueTests();
        System.debug('RunTestSchedulable - execute - END: ' + jobId);
    }

}
