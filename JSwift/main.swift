//
//  main.swift
//  JSwift
//
//  Created by Chris on 3/7/16.
//

import Foundation

var json = JSwift(fromFilePath: "/Users/crepanich23/json.txt")
print(json.jsonContents)
print("\n")
print(json.val["Event"])
print(json["Event"])
print("\n")
//Create objects from the main object as either [Any] or Dictionary<String, Any> depending on the json format