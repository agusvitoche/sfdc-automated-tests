/**
 * @description       : Test class for AutomatedTesting
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 03-27-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class AutomatedTestingTest {
    
    /**
    * @description Test AutomatedTesting.enqueueTests
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-27-2022 
    **/
    @isTest
    static void testEnqueueTests() {
        Test.startTest();
        AutomatedTesting.enqueueTests();
        Test.stopTest();
    }

    /**
    * @description Test AutomatedTesting.emailTestStatus
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-27-2022 
    **/
    @isTest
    static void testEmailTestStatus() {
        Test.setMock(HttpCalloutMock.class, new ToolingApiMock());
        Test.startTest();
        AutomatedTesting.emailTestStatus('7073N00001T2soTEST');
        Test.stopTest();
    }

    /**
    * @description Test AutomatedTesting.getCodeCoverageByClass
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-27-2022 
    **/
    @isTest
    static void testGetCodeCoverageByClass() {
        Test.setMock(HttpCalloutMock.class, new ToolingApiMock());
        Test.startTest();
        AutomatedTesting.getCodeCoverageByClass();
        Test.stopTest();
    }

    /**
    * @description Test AutomatedTesting.getLastTestExecution
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-27-2022 
    **/
    @isTest
    static void testGetLastTestExecution() {
        Test.startTest();
        AutomatedTesting.getLastTestExecution();
        Test.stopTest();
    }

}
