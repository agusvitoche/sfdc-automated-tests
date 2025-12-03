/**
 * @description       : Apex test code coverage wrapper
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 03-27-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class CodeCoverageWrapper {
    
    public Integer size { get; set; } 
    public Integer totalSize { get; set; } 
    public Boolean done { get; set; } 
    public Object queryLocator { get; set; } 
    public String entityTypeName { get; set; } 
    public List<Records> records { get; set; } 

    /**
    * @description CodeCoverageWrapper constructor
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-27-2022 
    * @param parser JSON parser
    **/
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
                        System.debug(LoggingLevel.WARN, 'CodeCoverageWrapper consuming unrecognized property: ' + text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }

    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-27-2022 
    * @param json 
    * @return CodeCoverageWrapper 
    **/
    public static CodeCoverageWrapper parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new CodeCoverageWrapper(parser);
    }

    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-27-2022 
    * @param parser 
    **/
    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT || curr == System.JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == System.JSONToken.END_OBJECT || curr == System.JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }

    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-27-2022 
    * @param p 
    * @return List<Records> 
    **/
    private static List<Records> arrayOfRecords(System.JSONParser p) {
        List<Records> res = new List<Records>();
        if (p.getCurrentToken() == null) {
            p.nextToken();
        }
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Records(p));
        }
        return res;
    }

    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-27-2022 
    * @param p 
    * @return List<Integer> 
    **/
    private static List<Integer> arrayOfInteger(System.JSONParser p) {
        List<Integer> res = new List<Integer>();
        if (p.getCurrentToken() == null) {
            p.nextToken();
        }
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getIntegerValue());
        }
        return res;
    }

    public class Records {
        
        public Attributes attributes { get; set; } 
        public Integer numLinesCovered { get; set; } 
        public String apexClassOrTriggerId { get; set; } 
        public ApexClassOrTrigger apexClassOrTrigger { get; set; } 
        public Integer numLinesUncovered { get; set; } 
        public Coverage coverage { get; set; } 

        /**
        * @description Records constructor
        * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-27-2022 
        * @param parser 
        **/
        public Records(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'attributes') {
                            attributes = new Attributes(parser);
                        } else if (text == 'NumLinesCovered') {
                            numLinesCovered = parser.getIntegerValue();
                        } else if (text == 'ApexClassOrTriggerId') {
                            apexClassOrTriggerId = parser.getText();
                        } else if (text == 'ApexClassOrTrigger') {
                            apexClassOrTrigger = new ApexClassOrTrigger(parser);
                        } else if (text == 'NumLinesUncovered') {
                            numLinesUncovered = parser.getIntegerValue();
                        } else if (text == 'Coverage') {
                            coverage = new Coverage(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Records consuming unrecognized property: ' + text);
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

        /**
        * @description Coverage constructor
        * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-27-2022 
        * @param parser 
        **/
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
                            System.debug(LoggingLevel.WARN, 'Coverage consuming unrecognized property: ' + text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class ApexClassOrTrigger {

        public Attributes attributes { get; set; } 
        public String name { get; set; } 

        /**
        * @description ApexClassOrTrigger constructor
        * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-27-2022 
        * @param parser 
        **/
        public ApexClassOrTrigger(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'attributes') {
                            attributes = new Attributes(parser);
                        } else if (text == 'Name') {
                            name = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'ApexClassOrTrigger consuming unrecognized property: ' + text);
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

        /**
        * @description Attributes constructor
        * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-27-2022 
        * @param parser 
        **/
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
                            System.debug(LoggingLevel.WARN, 'Attributes consuming unrecognized property: ' + text);
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

        /**
        * @description CoverageWrapper constructor
        * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-27-2022 
        * @param objectName Apex class tested
        * @param coverageValue Apex test code coverage
        **/
        public CoverageWrapper(String objectName, Decimal coverageValue) {
            this.objectName = objectName;
            this.coverageValue = coverageValue;
            this.intValue = coverageValue.intValue();
        }

        /**
        * @description Get coverageValue value
        * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-27-2022 
        * @return Decimal coverageValue value
        **/
        public Decimal getValue() {
            return this.coverageValue;
        }

        /**
        * @description Get objectName value
        * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-27-2022 
        * @return String objectName value
        **/
        public String getObjectName() {
            return this.objectName;
        }

        /**
        * @description Compares codecoverage with another CoverageWrapper
        * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-27-2022 
        * @param other Another CoverageWrapper to compare
        * @return Integer Positive the other CoverageWrapper is higher, Zero it is equals, Negative the other CoverageWrapper is lower
        **/
        public Integer compareTo(Object other) {
            return ((CoverageWrapper) other).intValue - intValue;
        }
    }

}
