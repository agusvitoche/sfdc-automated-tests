/**
 * @description       : Test class for RunTestSchedulable
 * @author            : Agustín M. Etcheverry
 * @last modified on  : 04-15-2022
 * @last modified by  : Agustín M. Etcheverry
**/
@isTest
public with sharing class RunTestSchedulableTest {
    
    @isTest
    static void testExecute() {
        Test.startTest();
        SchedulableContext sc = null;
        RunTestSchedulable sch = new RunTestSchedulable();
        sch.execute(sc);
        Test.stopTest();
    }

}
