//
//  AwesomeCache.swift
//  AwesomeData
//
//  Created by Evandro Harrison Hoffmann on 17/08/2016.
//  Copyright © 2016 It's Day Off. All rights reserved.
//

import UIKit

public class AwesomeCache: NSObject {
    
    /*
    *   Shared instance for Data Caching
    */
    public static let sharedInstance = AwesomeCache()
    
    static let cacheName = "AwesomeCache"
    
    /*
     *   Cache Object
     */
    private let cache: NSCache = {
//        // try getting the saved instance
//        if let cache = NSUserDefaults.standardUserDefaults().objectForKey(cacheName) as? NSCache {
//            AwesomeData.log("Recovered saved Cache")
//            return cache
//        }
        
        let cache = NSCache()
        cache.name = cacheName
        cache.countLimit = AwesomeData.cacheCountLimit
        cache.totalCostLimit = AwesomeData.cacheTotalCostLimit
        AwesomeData.log("Created new Cache")
        return cache
    }()
    
    /*
     *   Clears cached data
     */
    public static func clearCache(){
        AwesomeCache.sharedInstance.cache.removeAllObjects()
        //NSUserDefaults.standardUserDefaults().removeObjectForKey(cacheName)
        
        AwesomeData.log("Cache has been cleared")
    }
    
    /*
     *  Sets object to cache with url name
     *  @param data: NSData for caching
     *  @param url: url for caching
     */
    public static func setToCache(data: NSData?, url: String?){
        guard let url = url else{
            return
        }
        
        guard let data = data else{
            return
        }
        
        guard let hashUrl = AwesomeData.hashUrl(url) else {
            return
        }
        
        AwesomeCache.sharedInstance.cache.setObject(data, forKey: hashUrl)
        AwesomeData.log("object \(hashUrl) saved to cache")
    }
    
    /*
     *  Returns cached object, if any
     *  @param url: url to find cached Data
     */
    public static func getFromCache(url: String?) -> NSData?{
        guard let url = url else{
            return nil
        }
        
        guard let hashUrl = AwesomeData.hashUrl(url) else {
            return nil
        }
        
        if let data = AwesomeCache.sharedInstance.cache.objectForKey(hashUrl) as? NSData {
            AwesomeData.log("object \(hashUrl) recovered from cache")
            return data
        }
        
        return nil
    }
    
    /*
     *  Returns if either object is cached or not
     *  @param url: url to find cached Data
     */
    public static func isObjectCached(url: String?) -> Bool{
        return getFromCache(url) != nil
    }
}
