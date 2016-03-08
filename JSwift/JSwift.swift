//
//  JSwift.swift
//  JSwift
//
//  Created by Chris on 3/7/16.
//  Copyright © 2016 Chris Repanich. All rights reserved.
//

import Foundation

let JSON_QUOTE_TOKEN : Character = "\""
let JSON_OPEN_BRACE_TOKEN : Character = "{"
let JSON_CLOSE_BRACE_TOKEN : Character = "}"
let JSON_OPEN_BRACKET_TOKEN : Character = "["
let JSON_CLOSE_BRACKET_TOKEN : Character = "]"
let JSON_COMMA_TOKEN : Character = ","
let JSON_COLON_TOKEN : Character = ":"

class JSwift {
    var topDict: Dictionary<String, Any>
    var jsonContents: String
    var index: Int
    
    init(fromFilePath path: String) {
        topDict = Dictionary<String, Any>()
        jsonContents = ""
        index = 0
        //let filemgr = NSFileManager.defaultManager()
        do {
            jsonContents = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String
            buildJSON(jsonContents)
        } catch _ as NSError {
            //error reading
        }
        
    }
    subscript(key: String)->Any {
        get {
            //return object at key
            return topDict[key]
        }
        set (newValue) {
            //set new value
            topDict[key] = newValue
        }
    }
    
    func buildJSON(var json: String) {
        //remove any extra spaces to make parsing easier
        json = json.stringByReplacingOccurrencesOfString("\t", withString: "")
        json = json.stringByReplacingOccurrencesOfString("\n", withString: "")
        
        topDict = parseObject(json)
    }
    
    func parseObject(json: String)->Dictionary<String, Any> {
        var ret = Dictionary<String,Any>()
        var token = nextToken(json)
        var done = false
        //go through each value in this object
        while !done {
            //empty object
            if token == JSON_CLOSE_BRACE_TOKEN || token == JSON_CLOSE_BRACKET_TOKEN {
                return ret
            } else if token == JSON_COMMA_TOKEN {
                token = nextToken(json)
            } else if token == JSON_OPEN_BRACE_TOKEN || token == JSON_OPEN_BRACKET_TOKEN{
                token = nextToken(json)
            } else {
                //get lhs (name)
                let name = parseString(json)
                //check to make sure there is a colon
                token = nextToken(json)
                if token != JSON_COLON_TOKEN {
                    return ret  //bad
                }
                //get rhs
                let value = parseValue(json)
                ret[name] = value
                token = nextToken(json)
            }
        }
    }
    
    func parseArray(json: String)->[Any] {
        var ret = [Any]()
        while true {
            let temp = parseObject(json)
            if temp.isEmpty {
                break
            }
            ret.append(temp)
        }
        return ret
    }
    
    func parseValue(json: String)->Any {
        var token = nextToken(json)
        if token == JSON_OPEN_BRACE_TOKEN {
            return parseObject(json)
        } else if token == JSON_OPEN_BRACKET_TOKEN {
            return parseArray(json)
        } else {
            //parse the value
            if token == JSON_QUOTE_TOKEN {
                return parseString(json)
            } else {
                //can be value, boolean, or null
                if token >= "0" || token <= "9" {
                    //is digit, handle accordingly
                    var value = ""
                    while token != JSON_CLOSE_BRACE_TOKEN && token != JSON_CLOSE_BRACKET_TOKEN && token != JSON_COMMA_TOKEN {
                        value.append(token)
                        token = nextToken(json)
                    }
                    //backtrack one (from while check)
                    self.index--
                    return Double(value)
                } else {
                    //is true, false, or null
                    var value = ""
                    while token != JSON_CLOSE_BRACE_TOKEN || token != JSON_CLOSE_BRACKET_TOKEN || token != JSON_COMMA_TOKEN {
                        value.append(token)
                        token = nextToken(json)
                    }
                    //backtrack one (from while check)
                    self.index--
                    return value
                }
            }
        }
    }
    
    func parseString(json: String)->String {
        var name = ""
        var next = nextToken(json)
        while next != JSON_QUOTE_TOKEN {
            name.append(next)
            next = nextToken(json)
        }
        return name
    }

    func nextToken(json: String)->Character {
        self.index++
        return json[json.startIndex.advancedBy(self.index)]
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}