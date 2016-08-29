//
//  AwesomeParser.swift
//  AwesomeData
//
//  Created by Evandro Harrison Hoffmann on 6/2/16.
//  Copyright © 2016 It's Day Off. All rights reserved.
//

import UIKit

public class AwesomeParser: NSObject {

    public static func jsonObject(data: NSData?) -> AnyObject?{
        if let data = data {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                return json
            } catch {
                print("error serializing JSON: \(error)")
            }
        }
        
        return nil
    }
    
    public static func doubleValue(jsonObject: AnyObject, key: String) -> Double{
        if let value = jsonObject[key] as? Double {
            return value
        }else if let value = jsonObject[key] as? String {
            return Double(value)!
        }else if let array = jsonObject[key] as? [String] {
            return Double(array[0])!
        }
        return 0
    }
    
    public static func intValue(jsonObject: AnyObject, key: String) -> Int{
        if let value = jsonObject[key] as? Int {
            return value
        }else if let value = jsonObject[key] as? String {
            return Int(value)!
        }else if let array = jsonObject[key] as? [String] {
            return Int(array[0])!
        }
        return 0
    }
    
    public static func boolValue(jsonObject: AnyObject, key: String) -> Bool{
        if let value = jsonObject[key] as? Bool {
            return value
        }else if let value = jsonObject[key] as? String {
            return value.toBool()!
        }else if let array = jsonObject[key] as? [String] {
            return array[0].toBool()!
        }
        return false
    }
    
    public static func stringValue(jsonObject: AnyObject, key: String) -> String{
        if let value = jsonObject[key] as? String {
            return value
        }else if let array = jsonObject[key] as? [String] {
            return array[0]
        }else if let object = jsonObject[key] {
            if object == nil {
                return ""
            }
            return "\(object!)".removeNull()
        }
        return ""
    }
    
    public static func dateValue(jsonObject: AnyObject, key: String) -> NSDate?{
        let dateString = stringValue(jsonObject, key: key)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.dateFromString(dateString)
    }
    
    public static func propertyNamesOfObject(object: AnyObject) -> [String] {
        return Mirror(reflecting: object).children.filter { $0.label != nil }.map { $0.label! }
    }
    
    public static func propertyNamesOfClass(theClass: AnyClass) -> [String] {
        return Mirror(reflecting: theClass).children.filter { $0.label != nil }.map { $0.label! }
    }
}

extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
    
    func removeNull() -> String{
        if self == "<null>"{
            return ""
        }
        return self
    }
}
