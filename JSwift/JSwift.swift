//
//  JSwift.swift
//  JSwift
//
//  Created by Chris on 3/7/16.
//

import Foundation

let JSON_QUOTE_TOKEN : Character = "\""
let JSON_OPEN_BRACE_TOKEN : Character = "{"
let JSON_CLOSE_BRACE_TOKEN : Character = "}"
let JSON_OPEN_BRACKET_TOKEN : Character = "["
let JSON_CLOSE_BRACKET_TOKEN : Character = "]"
let JSON_COMMA_TOKEN : Character = ","
let JSON_COLON_TOKEN : Character = ":"
let LETTER_CHAR_SET = NSCharacterSet.letterCharacterSet()
class JSwift {
    var val: Dictionary<String, Any>
    var jsonContents: String
    var index: Int
    var length: Int
    init(fromString string: String) {
        val = Dictionary<String, Any>()
        index = 0
        jsonContents = string
        length = 0
        buildJSON(string)
    }
    
    init(fromFilePath path: String) {
        val = Dictionary<String, Any>()
        jsonContents = ""
        index = 0
        length = 0
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
            return val[key]
        }
        set (newValue) {
            //set new value
            val[key] = newValue
        }
    }
    
    func buildJSON(var json: String) {
        //remove any extra spaces to make parsing easier
        json = json.stringByReplacingOccurrencesOfString("\t", withString: "")
        json = json.stringByReplacingOccurrencesOfString("\n", withString: "")
        length = json.characters.count
        val = parseObject(json)
    }
    
    func parseObject(json: String)->Dictionary<String, Any> {
        var ret = Dictionary<String,Any>()
        var token = nextToken(json)
        //go through each value in this object
        while true {
            //empty object
            if length == self.index {
                return ret
            }
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
        while token == " " {
            token = nextToken(json)
        }
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
                
                if !LETTER_CHAR_SET.longCharacterIsMember(token.unicodeScalarCodePoint()) {
                    //is digit, handle accordingly
                    var value = ""
                    var isInt = true
                    while token != JSON_CLOSE_BRACE_TOKEN && token != JSON_CLOSE_BRACKET_TOKEN && token != JSON_COMMA_TOKEN {
                        value.append(token)
                        if token == "." {
                            isInt = false
                        }
                        
                        token = nextToken(json)
                    }
                    //backtrack one (from while check)
                    self.index--
                    if isInt {return Int(value)}
                    return Double(value)
                } else {
                    //is true, false, or null
                    var value = ""
                    while token != JSON_CLOSE_BRACE_TOKEN && token != JSON_CLOSE_BRACKET_TOKEN && token != JSON_COMMA_TOKEN {
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

extension Character
{
    func unicodeScalarCodePoint() -> UInt32
    {
        let characterString = String(self)
        let scalars = characterString.unicodeScalars
        
        return scalars[scalars.startIndex].value
    }
}