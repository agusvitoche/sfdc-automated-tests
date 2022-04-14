/**
 * @description       : Wrapper for code coverage apex tests response in tooling API
 * @author            : Agustín M. Etcheverry
 * @last modified on  : 04-15-2022
 * @last modified by  : Agustín M. Etcheverry
**/
public with sharing class CodeCoverageWrapper {
    
    public Integer size { get; set; } 
    public Integer totalSize { get; set; } 
    public Boolean done { get; set; } 
    public Object queryLocator { get; set; } 
    public String entityTypeName { get; set; } 
    public List<Records> records { get; set; } 

    public CodeCoverageWrapper(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'size') {
                        size = parser.getIntegerValue();
                    } else if (text == 'totalSize') {
                        totalSize = parser.getIntegerValue();
                    } else if (text == 'done') {
                        done = parser.getBooleanValue();
                    } else if (text == 'queryLocator') {
                        queryLocator = parser.readValueAs(Object.class);
                    } else if (text == 'entityTypeName') {
                        entityTypeName = parser.getText();
                    } else if (text == 'records') {
                        records = arrayOfRecords(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'CodeCoverageWrapper consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }

    public static CodeCoverageWrapper parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new CodeCoverageWrapper(parser);
    }

    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT || 
                curr == System.JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == System.JSONToken.END_OBJECT ||
                curr == System.JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }

    private static List<Records> arrayOfRecords(System.JSONParser p) {
        List<Records> res = new List<Records>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Records(p));
        }
        return res;
    }

    private static List<Integer> arrayOfInteger(System.JSONParser p) {
        List<Integer> res = new List<Integer>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getIntegerValue());
        }
        return res;
    }

    public class Records {
        
        public Attributes attributes { get; set; } 
        public Integer NumLinesCovered { get; set; } 
        public String ApexClassOrTriggerId { get; set; } 
        public ApexClassOrTrigger ApexClassOrTrigger { get; set; } 
        public Integer NumLinesUncovered { get; set; } 
        public Coverage Coverage { get; set; } 

        public Records(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'attributes') {
                            attributes = new Attributes(parser);
                        } else if (text == 'NumLinesCovered') {
                            NumLinesCovered = parser.getIntegerValue();
                        } else if (text == 'ApexClassOrTriggerId') {
                            ApexClassOrTriggerId = parser.getText();
                        } else if (text == 'ApexClassOrTrigger') {
                            ApexClassOrTrigger = new ApexClassOrTrigger(parser);
                        } else if (text == 'NumLinesUncovered') {
                            NumLinesUncovered = parser.getIntegerValue();
                        } else if (text == 'Coverage') {
                            Coverage = new Coverage(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Records consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class Coverage {

        public List<Integer> coveredLines { get; set; } 
        public List<Integer> uncoveredLines { get; set; } 

        public Coverage(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'coveredLines') {
                            coveredLines = arrayOfInteger(parser);
                        } else if (text == 'uncoveredLines') {
                            uncoveredLines = arrayOfInteger(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Coverage consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class ApexClassOrTrigger {

        public Attributes attributes { get; set; } 
        public String Name { get; set; } 

        public ApexClassOrTrigger(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'attributes') {
                            attributes = new Attributes(parser);
                        } else if (text == 'Name') {
                            Name = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'ApexClassOrTrigger consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class Attributes {

        public String type_Z { get; set; } // in json: type
        public String url { get; set; } 

        public Attributes(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'type') {
                            type_Z = parser.getText();
                        } else if (text == 'url') {
                            url = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Attributes consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class CoverageWrapper implements Comparable {

        private Decimal coverageValue { get; set; }
        private String objectName { get; set; }
        private Integer intValue { get; set; }

        public CoverageWrapper(String objectName, Decimal coverageValue) {
            this.objectName = objectName;
            this.coverageValue = coverageValue;
            this.intValue = coverageValue.intValue();
        }

        public Decimal getValue() {
            return this.coverageValue;
        }

        public String getObjectName() {
            return this.objectName;
        }

        public Integer compareTo(Object other) {
            return ((CoverageWrapper) other).intValue - intValue;
        }
    }
    
}