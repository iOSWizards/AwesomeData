//
//  CacheFile.swift
//  AwesomeData
//
//  Created by Evandro Harrison Hoffmann on 27/08/2016.
//  Copyright © 2016 It's Day Off. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import AwesomeData

extension AwesomeCacheFile {
    
    @NSManaged var name: String?
    @NSManaged var file: NSData?
    
}

public class AwesomeCacheFile: NSManagedObject {

    /*
    *   Saves image to Cache Database
    *   @param url: url for path
    *   @param image: Image for caching
    */
    public static func cache(urlString url: String?, image: UIImage?){
        guard let image = image else{
            return
        }
        
        cache(urlString: url, data: UIImageJPEGRepresentation(image, 1))
    }
    
    /*
     *   Saves image to Cache Database
     *   @param url: url for path
     *   @param data: NSData for caching
     */
    public static func cache(urlString url: String?, data: NSData?){
        guard let url = url else{
            return
        }
        
        guard let data = data else{
            return
        }
        
        guard let hashUrl = AwesomeData.hashUrl(url) else {
            return
        }
        
        if let cacheFile = AwesomeCacheFile.getObject(predicate: NSPredicate(format: "name == %@", hashUrl), createIfNil: true) as? AwesomeCacheFile {
            cacheFile.name = hashUrl
            cacheFile.file = data
            save()
            
            AwesomeData.log("caching data for url: \(hashUrl)")
        }
    }
    
    /*
     *  Returns the cached object, if any
     *  @param url: Url for fetching cached object
     */
    public static func getCached(urlString url: String?) -> AwesomeCacheFile? {
        guard let url = url else{
            return nil
        }
        
        guard let hashUrl = AwesomeData.hashUrl(url) else {
            return nil
        }
        
        return AwesomeCacheFile.getObject(predicate: NSPredicate(format: "name == %@", hashUrl)) as? AwesomeCacheFile
    }
    
    /*
     *  Clears Cache Database
     */
    public static func clearCache(){
        let cacheFiles = list()
        for cacheFile in cacheFiles {
            cacheFile.deleteInstance()
        }
        
        save()
        
        AwesomeData.log("cleared cache for \(String(self))")
    }

}
