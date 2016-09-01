//
//  AwesomeCacheManager.swift
//  Micro Learning App
//
//  Created by Evandro Harrison Hoffmann on 01/09/2016.
//  Copyright © 2016 Mindvalley. All rights reserved.
//

import UIKit

public class AwesomeCacheManager: NSObject {

    /*
    *   Sets the cache size for the application
    *   @param memorySize: Size of cache in memory
    *   @param diskSize: Size of cache in disk
    */
    public static func configureCache(withMemorySize memorySize: Int = 4, diskSize: Int = 20){
        let cacheSizeMemory = memorySize*1024*1024
        let cacheSizeDisk = diskSize*1024*1024
        let cache = NSURLCache(memoryCapacity: cacheSizeMemory, diskCapacity: cacheSizeDisk, diskPath: nil)
        NSURLCache.setSharedURLCache(cache)
    }
    
    /*
     *   Clears cache
     */
    public static func clearCache(){
        NSURLCache.sharedURLCache().removeAllCachedResponses()
    }
    
    /*
     *   Get cached object for urlRequest
     *   @param urlRequest: Request for cached data
     */
    public static func getCachedObject(urlRequest: NSURLRequest) -> NSData?{
        if let cachedObject = NSURLCache.sharedURLCache().cachedResponseForRequest(urlRequest) {
            return cachedObject.data
        }
        return nil
    }
    
    /*
     *   Set object to cache
     *   @param data: data to cache
     */
    public static func cacheObject(urlRequest: NSURLRequest?, response: NSURLResponse?, data: NSData?){
        guard let urlRequest = urlRequest else{
            return
        }
        
        guard let response = response else{
            return
        }
        
        guard let data = data else{
            return
        }
        
        let cachedResponse = NSCachedURLResponse(response: response, data: data)
        NSURLCache.sharedURLCache().storeCachedResponse(cachedResponse, forRequest: urlRequest)
    }
    
}
