//
//  JSwift.swift
//  JSwift
//
//  Created by Chris on 3/7/16.
//  Copyright © 2016 Chris Repanich. All rights reserved.
//

import Foundation


class JSwift {
    var topDict: Dictionary<String, Any>
    var jsonContents: String
    init(fromFilePath path: String) {
        topDict = Dictionary<String, Any>()
        jsonContents = ""
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
        
        if json[json.startIndex] == "{" {
            json = json.substringFromIndex(json.startIndex.successor())
        }
    }
    
    func getValuePair(json: String)->(String, Any) {
        //get the value before the first colon and the value after. 
        return ("", "")
    }
}