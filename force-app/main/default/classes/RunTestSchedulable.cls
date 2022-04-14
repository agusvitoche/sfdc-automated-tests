/**
 * @description       : Run the tests execution
 * @author            : Agustín M. Etcheverry
 * @last modified on  : 04-15-2022
 * @last modified by  : Agustín M. Etcheverry
**/
global with sharing class RunTestSchedulable implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        System.debug('RunTestSchedulable - execute - START');

        Id jobId = AutomatedTesting.enqueueTests();

        System.debug('RunTestSchedulable - execute - END: ' + jobId);
    }

}
