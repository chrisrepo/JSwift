# JSwift
Swift JSON Parser

Create JSON Objects from strings  
`var json = JSwift(fromFilePath: "examplePath/json.txt")`  
`print(json.val["Events"])`    
Cast children of the main object as either [Any] or Dictionary<String, Any> depending on the json format  
`var eventArray = json.val["Events"] as! [Any]`  
`var eventDescription = eventArray[0] as! Dictionary<String, Any>`  
`print(eventArray[0])`  
`print(eventDescription["Name"]!)`  
`print(eventDescription["NumberOfAttendees"])`  
