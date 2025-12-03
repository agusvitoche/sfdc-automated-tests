/**
 * @description       : Test class for TestResultSchedulable
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 03-27-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class TestResultSchedulableTest {
    
    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-27-2022 
    **/
    @isTest
    static void testExecute() {
        Test.setMock(HttpCalloutMock.class, new ToolingApiMock());
        Test.startTest();
        SchedulableContext sc = null;
        TestResultSchedulable sch = new TestResultSchedulable();
        sch.execute(sc);
        Test.stopTest();
    }

}
