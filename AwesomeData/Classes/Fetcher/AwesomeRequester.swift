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

open class AwesomeRequester: NSObject {
    // MARK:- Where the magic happens
    
    /*
    *   Fetch data from URL with NSUrlSession
    *   @param urlString: Url to fetch data form
    *   @param method: URL method to fetch data using URLMethod enum
    *   @param headerValues: Any header values to complete the request
    *   @param shouldCache: Cache fetched data, if on, it will check first for data in cache, then fetch if not found
    *   @param completion: Returns fetched NSData in a block
    */
    open static func performRequest(_ urlString: String?, method: URLMethod? = .GET, bodyData: Data? = nil, headerValues: [[String]]? = nil, shouldCache: Bool = false, timeoutAfter timeout: TimeInterval = 0, completion:@escaping (_ data: Data?) -> Void) -> URLSessionDataTask?{
        guard let urlString = urlString else {
            completion(nil)
            return nil
        }
        
        if urlString == "Optional(<null>)" {
            completion(nil)
            return nil
        }
        
        guard let url = URL(string: urlString) else{
            completion(nil)
            return nil
        }
        
        let urlRequest = NSMutableURLRequest(url: url)
        //urlRequest.cachePolicy = .ReturnCacheDataElseLoad
        
        // check if file been cached already
        if shouldCache {
            if let data = AwesomeCacheManager.getCachedObject(urlRequest as URLRequest) {
                completion(data)
                return nil
            }
        }
        
        // Continue to URL request

        if let method = method {
            urlRequest.httpMethod = method.rawValue
        }
        
        if let bodyData = bodyData {
            urlRequest.httpBody = bodyData
        }
        
        if let headerValues = headerValues {
            for headerValue in headerValues {
                urlRequest.addValue(headerValue[0], forHTTPHeaderField: headerValue[1])
            }
        }
        
        if timeout > 0 {
            urlRequest.timeoutInterval = timeout
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest as URLRequest) { (data, response, error) in
            DispatchQueue.main.async(execute: {
                if let error = error{
                    print("There was an error \(error)")
                    completion(nil)
                }else{
                    if shouldCache {
                        AwesomeCacheManager.cacheObject(urlRequest as URLRequest, response: response, data: data)
                    }
                    completion(data)
                }
            })
        }
        task.resume()
        
        return task
    }
}

// MARK: - Custom Calls

extension AwesomeRequester {
    
    /*
     *   Fetch data from URL with NSUrlSession, with a timeout
     *   @param urlString: Url to fetch data form
     *   @param timeOut: Timeout time
     *   @param completion: Returns fetched NSData in a block
     */
    public static func performRequest(_ urlString: String?, timeOut: Double, timeoutAfter timeout: TimeInterval = 0, completion:@escaping (_ data: Data?) -> Void){
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
            var canTimeOut = true
            var timedOut = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(timeOut * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                if (canTimeOut) {
                    timedOut = true
                    completion(nil)
                }
            })
            
            performRequest(urlString, timeoutAfter: timeout, completion: { (data) in
                canTimeOut = false;
                
                DispatchQueue.main.async(execute: {
                    if let data = data{
                        if !timedOut {
                            completion(data)
                        }
                    }else{
                        if(!timedOut){
                            completion(nil)
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
    public static func performRequest(_ urlString: String?, body: String?, timeoutAfter timeout: TimeInterval = 0, completion:@escaping (_ data: Data?) -> Void) -> URLSessionDataTask?{
        if let body = body {
            return performRequest(urlString, method: nil, bodyData: body.data(using: String.Encoding.utf8), headerValues: nil, shouldCache: false, timeoutAfter: timeout, completion: completion)
        }
        return performRequest(urlString, method: nil, bodyData: nil, headerValues: nil, shouldCache: false, timeoutAfter: timeout, completion: completion)
    }
    
    /*
     *   Fetch data from URL with NSUrlSession
     *   @param urlString: Url to fetch data form
     *   @param method: URL method to fetch data using URLMethod enum
     *   @param jsonBody: adds json (Dictionary) body to request
     *   @param completion: Returns fetched NSData in a block
     */
    public static func performRequest(_ urlString: String?, method: URLMethod?, jsonBody: [String: AnyObject]?, timeoutAfter timeout: TimeInterval = 0, completion:@escaping (_ data: Data?) -> Void) -> URLSessionDataTask? {
        var data: Data?
        var headerValues = [[String]]()
        if let jsonBody = jsonBody {
            do {
                try data = JSONSerialization.data(withJSONObject: jsonBody, options: .prettyPrinted)
                headerValues.append(["application/json", "Content-Type"])
                headerValues.append(["application/json", "Accept"])
            } catch{
                NSLog("Error unwraping json object")
            }
        }
        
        return performRequest(urlString, method: method, bodyData: data, headerValues: headerValues, shouldCache: false, timeoutAfter: timeout, completion: completion)
    }
    
    /*
     *   Fetch data from URL with NSUrlSession
     *   @param urlString: Url to fetch data form
     *   @param method: URL method to fetch data using URLMethod enum
     *   @param jsonBody: adds json (Dictionary) body to request
     *   @param authorization: adds request Authorization token to header
     *   @param completion: Returns fetched NSData in a block
     */
    public static func performRequest(_ urlString: String?, method: URLMethod? = .GET, jsonBody: [String: AnyObject]? = nil, authorization: String, timeoutAfter timeout: TimeInterval = 0, completion:@escaping (_ data: Data?) -> Void) -> URLSessionDataTask? {
        return performRequest(
            urlString,
            method: method,
            jsonBody: jsonBody,
            headers: ["Authorization": authorization],
            timeoutAfter: timeout,
            completion: completion
        )
    }
    
    /*
     *   Fetch data from URL with NSUrlSession
     *   @param urlString: Url to fetch data form
     *   @param method: URL method to fetch data using URLMethod enum
     *   @param jsonBody: adds json (Dictionary) body to request
     *   @param headers: adds headers to the request
     *   @param timeout: adds the request timeout
     *   @param completion: Returns fetched NSData in a block
     */
    public static func performRequest(_ urlString: String?, method: URLMethod? = .GET, jsonBody: [String: AnyObject]? = nil, headers: [String: String], timeoutAfter timeout: TimeInterval = 0, completion:@escaping (_ data: Data?) -> Void) -> URLSessionDataTask? {
        
        var data: Data?
        var headerValues = [[String]]()
        
        if let jsonBody = jsonBody {
            do {
                try data = JSONSerialization.data(withJSONObject: jsonBody, options: .prettyPrinted)
                headerValues.append(["application/json", "Content-Type"])
                headerValues.append(["application/json", "Accept"])
            } catch{
                NSLog("Error unwraping json object")
            }
        }
        
        for (key, value) in headers {
            headerValues.append([value, key])
        }
        
        return performRequest(
            urlString,
            method: method,
            bodyData: data,
            headerValues: headerValues,
            shouldCache: false,
            timeoutAfter: timeout,
            completion: completion
        )
    }
    
}

