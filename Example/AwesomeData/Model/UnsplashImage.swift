//
//  UnsplashImage.swift
//  AwesomeData
//
//  Created by Evandro Harrison Hoffmann on 27/08/2016.
//  Copyright © 2016 It's Day Off. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension UnsplashImage {
    
    @NSManaged var format: String?
    @NSManaged var filename: String?
    @NSManaged var author: String?
    @NSManaged var authorUrl: String?
    @NSManaged var postUrl: String?
    @NSManaged var width: NSNumber?
    @NSManaged var height: NSNumber?
    @NSManaged var objectId: NSNumber?
    
}

class UnsplashImage: NSManagedObject {
    
    static var sortedList: [UnsplashImage] {
        return list(sortWith: "objectId", ascending: true) as! [UnsplashImage]
    }
    
    func imageUrl(_ size: CGSize = CGSize(width: 0, height: 0)) -> String {
        guard let objectId = objectId else{
            return ""
        }
        
        var customSize = size
        if customSize.width == 0 {
            customSize.width = CGFloat(self.width!.int32Value)
        }
        if customSize.height == 0 {
            customSize.height = CGFloat(self.height!.int32Value)
        }
        
        return String(format:"https://unsplash.it/%d/%d?image=%d", Int(customSize.width), Int(customSize.height), objectId.int32Value)
    }

    //MARK: - JSON PARSING
    
    static func parseJSONArray(_ jsonArray: AnyObject?) -> [UnsplashImage]{
        var objects = [UnsplashImage]()
        
        if let jsonArray = jsonArray as? [[String: AnyObject]] {
            for object in jsonArray {
                if let parsedObject = parseJSONObject(object){
                    objects.append(parsedObject)
                }
            }
        }
        
        return objects
    }

    static func parseJSONObject(_ jsonObject: [String: AnyObject]) -> UnsplashImage?{
        
        let objectId = parseInt(jsonObject, key: "id")
        if let unsplashImage = getObject(predicate: NSPredicate(format: "objectId == %d", objectId.int32Value), createIfNil: true) as? UnsplashImage {
            unsplashImage.objectId = objectId
            unsplashImage.width = parseDouble(jsonObject, key: "width")
            unsplashImage.height = parseInt(jsonObject, key: "height")
            unsplashImage.format = parseString(jsonObject, key: "format")
            unsplashImage.filename = parseString(jsonObject, key: "filename")
            unsplashImage.author = parseString(jsonObject, key: "author")
            unsplashImage.authorUrl = parseString(jsonObject, key: "author_url")
            unsplashImage.postUrl = parseString(jsonObject, key: "post_url")
            
            return unsplashImage
        }
        
        return nil
    }

}
