/**
 * @description       : Test class for RunTestSchedulable
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 03-27-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class RunTestSchedulableTest {
    
    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-27-2022 
    **/
    @isTest
    static void testExecute() {
        Test.startTest();
        SchedulableContext sc = null;
        RunTestSchedulable sch = new RunTestSchedulable();
        sch.execute(sc);
        Test.stopTest();
    }

}
