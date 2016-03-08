//
//  Test.swift
//  JSwift
//
//  Created by Chris on 3/7/16.
//  Copyright © 2016 Chris Repanich. All rights reserved.
//

import Foundation

var json = JSwift(fromFilePath: "/Users/crepanich23/json.txt")
print(json.jsonContents)
print("\n")
print(json.val["Events"])
print("\n")
//Cast children of the main object as either [Any] or Dictionary<String, Any> depending on the json format
var eventArray = json.val["Events"] as! [Any]
var eventDescription = eventArray[0] as! Dictionary<String, Any>
print(eventArray[0])
print("\n")
print(eventDescription["Name"]!)
print(eventDescription["NumberOfAttendees"])