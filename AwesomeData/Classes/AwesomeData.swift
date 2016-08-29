//
//  AwesomeData.swift
//  AwesomeData
//
//  Created by Evandro Harrison Hoffmann on 27/08/2016.
//  Copyright © 2016 It's Day Off. All rights reserved.
//

import UIKit

public class AwesomeData: NSObject {

    public static let cacheCountLimit     = 50
    public static let cacheTotalCostLimit = 1024*1024
    
    public static var showLogs = false
    
    /*
     *  Print logs if activated
     *  @param message: Message to log
     */
    public static func log(message: String){
        if showLogs {
            print(message)
        }
    }
    
    /*
     *  Transforms URL to Hash
     *  @param url: Url to transform
     */
    public static func hashUrl(url: String) -> String? {
        let urlArray = url.componentsSeparatedByString("/")
        if urlArray.count > 2 {
            return urlArray[2] + ":" + urlArray.last!
        }
        return nil
    }
    
    /*
     *  Sets Database
     *  @param name: Name of the database
     */
    public static func setDatabase(name: String){
        AwesomeDataAccess.sharedInstance.setDatabase(name)
    }
    
    /*
     *  Save Database Context
     */
    public static func saveContext(){
        AwesomeDataAccess.sharedInstance.saveContext()
    }
    
}
