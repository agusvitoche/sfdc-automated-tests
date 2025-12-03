/**
 * @description       : Mock for test tooling api requests
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 03-27-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class ToolingApiMock {
    
    /**
    * @description Mock responde from tooling api
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-27-2022 
    * @param req Request maded it to tooling api
    * @return HTTPResponse Mocked response
    **/
    public HTTPResponse respond(HTTPRequest req) {
        
        // Response by default
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"foo":"bar"}');
        res.setStatusCode(200);
        
        // Particular responses
        if (req.getEndpoint().contains('ApexCodeCoverageAggregate')) {
            res = getApexCodeCoverageAggregateResponse();
        }
        
        return res;
    }
    
    /**
    * @description Generate fake apex test code coverage json
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-27-2022 
    * @return HttpResponse Fake apex test code coverage json response
    **/
    private static HttpResponse getApexCodeCoverageAggregateResponse() {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"records":[{"ApexClassOrTrigger": {"Name": "CustomClass"}, "NumLinesCovered": 10, "NumLinesUncovered": 9}]}');
        res.setStatusCode(200);
        return res;
    }

}
