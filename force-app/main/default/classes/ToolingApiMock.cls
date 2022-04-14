/**
 * @description       : Mock for Salesforce Tooling API
 * @author            : Agustín M. Etcheverry
 * @last modified on  : 04-15-2022
 * @last modified by  : Agustín M. Etcheverry
**/
@isTest
public class ToolingApiMock implements HttpCalloutMock {

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
    
    private static HttpResponse getApexCodeCoverageAggregateResponse() {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"records":[{"ApexClassOrTrigger": {"Name": "CustomClass"}, "NumLinesCovered": 10, "NumLinesUncovered": 9}]}');
        res.setStatusCode(200);
        return res;
    }
    
}