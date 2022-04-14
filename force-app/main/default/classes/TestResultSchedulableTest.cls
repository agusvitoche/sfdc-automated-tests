/**
 * @description       : Test class for RunTestSchedulable
 * @author            : Agustín M. Etcheverry
 * @last modified on  : 04-15-2022
 * @last modified by  : Agustín M. Etcheverry
**/
@isTest
public with sharing class TestResultSchedulable {
    
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
