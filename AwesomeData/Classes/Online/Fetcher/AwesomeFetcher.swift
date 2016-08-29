//
//  AwesomeFetcher.swift
//  AwesomeData
//
//  Created by Evandro Harrison Hoffmann on 6/2/16.
//  Copyright © 2016 It's Day Off. All rights reserved.
//

import UIKit

public enum URLMethod: String {
    case GET = "GET"
    case POST = "POST"
    case DELETE = "DELETE"
    case PUT = "PUT"
}

public class AwesomeFetcher: NSObject {
    // MARK:- Where the magic happens
    
    /*
    *   Fetch data from URL with NSUrlSession
    *   @param urlString: Url to fetch data form
    *   @param method: URL method to fetch data using URLMethod enum
    *   @param headerValues: Any header values to complete the request
    *   @param shouldCache: Cache fetched data, if on, it will check first for data in cache, then fetch if not found
    *   @param completion: Returns fetched NSData in a block
    */
    public static func fetchData(urlString: String?, method: URLMethod? = .GET, bodyData: NSData? = nil, headerValues: [[String]]? = nil, shouldCache: Bool = false, completion:(data: NSData?) -> Void) -> NSURLSessionDataTask?{
        guard let urlString = urlString else {
            completion(data: nil)
            return nil
        }
        
        if urlString == "Optional(<null>)" {
            completion(data: nil)
            return nil
        }
        
        // check if file been cached already
        if shouldCache {
            if let object = AwesomeCache.getFromCache(urlString) {
                completion(data: object)
                return nil
            }
        }
        
        // Continue to URL request
        
        guard let url = NSURL(string: urlString) else{
            completion(data: nil)
            return nil
        }
        
        let urlRequest = NSMutableURLRequest(URL: url)
        //urlRequest.cachePolicy = .ReturnCacheDataElseLoad
        
        if let method = method {
            urlRequest.HTTPMethod = method.rawValue
        }
        
        if let bodyData = bodyData {
            urlRequest.HTTPBody = bodyData
        }
        
        if let headerValues = headerValues {
            for headerValue in headerValues {
                urlRequest.addValue(headerValue[0], forHTTPHeaderField: headerValue[1])
            }
        }
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) in
            dispatch_async(dispatch_get_main_queue(), {
                if let error = error{
                    print("There was an error \(error)")
                    completion(data: nil)
                }else{
                    if shouldCache {
                        AwesomeCache.setToCache(data, url: urlString)
                    }
                    completion(data: data)
                }
            })
        })
        task.resume()
        
        return task
    }
}

// MARK: - Custom Calls

extension AwesomeFetcher {
    
    /*
     *   Fetch data from URL with NSUrlSession, with a timeout
     *   @param urlString: Url to fetch data form
     *   @param timeOut: Timeout time
     *   @param completion: Returns fetched NSData in a block
     */
    public static func fetchData(urlString: String?, timeOut: Double, completion:(data: NSData?) -> Void){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            var canTimeOut = true
            var timedOut = false
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(timeOut * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                if (canTimeOut) {
                    timedOut = true
                    completion(data:nil)
                }
            })
            
            fetchData(urlString, completion: { (data) in
                canTimeOut = false;
                
                dispatch_async(dispatch_get_main_queue(), {
                    if let data = data{
                        if !timedOut {
                            completion(data:data)
                        }
                    }else{
                        if(!timedOut){
                            completion(data:nil)
                        }
                    }
                })
            })
        }
    }
    
    /*
     *   Fetch data from URL with NSUrlSession
     *   @param urlString: Url to fetch data form
     *   @param body: adds body to request, can be of any kind
     *   @param completion: Returns fetched NSData in a block
     */
    public static func fetchData(urlString: String?, body: String?, completion:(data: NSData?) -> Void) -> NSURLSessionDataTask?{
        if let body = body {
            return fetchData(urlString, method: nil, bodyData: body.dataUsingEncoding(NSUTF8StringEncoding), headerValues: nil, shouldCache: false, completion: completion)
        }
        return fetchData(urlString, method: nil, bodyData: nil, headerValues: nil, shouldCache: false, completion: completion)
    }
    
    /*
     *   Fetch data from URL with NSUrlSession
     *   @param urlString: Url to fetch data form
     *   @param method: URL method to fetch data using URLMethod enum
     *   @param jsonBody: adds json (Dictionary) body to request
     *   @param completion: Returns fetched NSData in a block
     */
    public static func fetchData(urlString: String?, method: URLMethod?, jsonBody: [String: AnyObject]?, completion:(data: NSData?) -> Void) -> NSURLSessionDataTask? {
        var data: NSData?
        var headerValues = [[String]]()
        if let jsonBody = jsonBody {
            do {
                try data = NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
                headerValues.append(["application/json", "Content-Type"])
                headerValues.append(["application/json", "Accept"])
            } catch{
                NSLog("Error unwraping json object")
            }
        }
        
        return fetchData(urlString, method: method, bodyData: data, headerValues: headerValues, shouldCache: false, completion: completion)
    }
    
    /*
     *   Fetch data from URL with NSUrlSession
     *   @param urlString: Url to fetch data form
     *   @param method: URL method to fetch data using URLMethod enum
     *   @param jsonBody: adds json (Dictionary) body to request
     *   @param authorization: adds request Authorization token to header
     *   @param completion: Returns fetched NSData in a block
     */
    public static func fetchData(urlString: String?, method: URLMethod? = .GET, jsonBody: [String: AnyObject]? = nil, authorization: String, completion:(data: NSData?) -> Void) -> NSURLSessionDataTask? {
        var data: NSData?
        var headerValues = [[String]]()
        if let jsonBody = jsonBody {
            do {
                try data = NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
                headerValues.append(["application/json", "Content-Type"])
                headerValues.append(["application/json", "Accept"])
            } catch{
                NSLog("Error unwraping json object")
            }
        }
        
        headerValues.append([authorization, "Authorization"])
        
        return fetchData(urlString, method: method, bodyData: data, headerValues: headerValues, shouldCache: false, completion: completion)
    }
    
}

