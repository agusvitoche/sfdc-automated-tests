/**
 * @description       : Test class for AutomatedTesting
 * @author            : Agustín M. Etcheverry
 * @last modified on  : 04-15-2022
 * @last modified by  : Agustín M. Etcheverry
**/
@isTest
public with sharing class AutomatedTestingTest {
    
    @isTest
    static void testEnqueueTests() {
        Test.startTest();
        AutomatedTesting.enqueueTests();
        Test.stopTest();
    }

    @isTest
    static void testEmailTestStatus() {
        Test.setMock(HttpCalloutMock.class, new ToolingApiMock());
        Test.startTest();
        AutomatedTesting.emailTestStatus('7073N00001T2soTEST');
        Test.stopTest();
    }

    @isTest
    static void testGetCodeCoverageByClass() {
        Test.setMock(HttpCalloutMock.class, new ToolingApiMock());
        Test.startTest();
        AutomatedTesting.getCodeCoverageByClass();
        Test.stopTest();
    }

    @isTest
    static void testGetLastTestExecution() {
        Test.startTest();
        AutomatedTesting.getLastTestExecution();
        Test.stopTest();
    }

}
