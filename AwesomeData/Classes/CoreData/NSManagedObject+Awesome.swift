//
//  NSManagedObject+Awesome.swift
//  AwesomeData
//
//  Created by Evandro Harrison Hoffmann on 02/08/2016.
//  Copyright © 2016 It's Day Off. All rights reserved.
//

import CoreData

// MARK: - Coredata Configuration

extension NSManagedObject {
    
    /*
     *  Saves context. (commits database)
     *  @param managedContext: context for wanted database | as default, will get the standard Coredata shared instance for the App
     */
    public static func save(withContext managedContext: NSManagedObjectContext = AwesomeDataAccess.sharedInstance.managedObjectContext){
        do {
            try managedContext.save()
        } catch {
            let nserror = error as NSError
            NSLog("Could not save \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
    
    /*
     *  Creates a new instance of the current NSManagedObject
     *  @param managedContext: as default, will get the standard Coredata shared instance for the App
     */
    public static func newInstance(withContext managedContext: NSManagedObjectContext = AwesomeDataAccess.sharedInstance.managedObjectContext) -> NSManagedObject{
        let entity =  NSEntityDescription.entityForName(String(self), inManagedObjectContext:managedContext)
        return NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
    }
    
    /*
     *  Deletes the instance of the current instance of NSManagedObject
     *  @param managedContext: context for wanted database | as default, will get the standard Coredata shared instance for the App
     */
    public func deleteInstance(withContext managedContext: NSManagedObjectContext = AwesomeDataAccess.sharedInstance.managedObjectContext){
        managedContext.deleteObject(self)
    }
    
    /*
     *  Lists all instances of the current NSManagedObject with sortDescriptor
     *  @param managedContext: context for wanted database | as default, will get the standard Coredata shared instance for the App
     *  @param sortDescriptor: NSSortDescriptor with sort params
     */
    public static func list(withContext managedContext: NSManagedObjectContext = AwesomeDataAccess.sharedInstance.managedObjectContext, sortDescriptor: NSSortDescriptor? = nil, predicate: NSPredicate? = nil) -> [NSManagedObject]{
        let fetchRequest = NSFetchRequest(entityName:String(self))
        
        if let sortDescriptor = sortDescriptor {
            fetchRequest.sortDescriptors = [sortDescriptor]
        }
        
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        
        var fetchedResults: [NSManagedObject]!
        do {
            try fetchedResults = managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            
            if let results: [NSManagedObject] = fetchedResults {
                return results
            }
        }catch{
            let nserror = error as NSError
            print("Could not fetch \(nserror), \(nserror.userInfo)")
        }
        
        return fetchedResults
    }
    
    /*
     *  Returns the first instance of a list of Fetched NSManagedObject based on predicate filtering
     *  @param managedContext: context for wanted database | as default, will get the standard Coredata shared instance for the App
     *  @param predicate: NSPredicate for filtering results
     *  @param createIfNil: if set to true, it will return a new instance of the NSManagedObject in case it doesn't find a match
     */
    public static func getObject(withContext managedContext: NSManagedObjectContext = AwesomeDataAccess.sharedInstance.managedObjectContext, predicate: NSPredicate, createIfNil: Bool = false) -> NSManagedObject? {
        let fetchedObjects: [NSManagedObject]? = list(withContext: managedContext, predicate: predicate)
        
        if let fetchedObjects = fetchedObjects {
            if fetchedObjects.count > 0{
                if AwesomeData.showLogs { print("fetched \(fetchedObjects.count) \(String(self)) with predicate \(predicate)") }
                return fetchedObjects.first
            }
        }
        
        if createIfNil {
            if AwesomeData.showLogs { print("creating new instance of \(String(self))") }
            return newInstance(withContext: managedContext)
        }
        
        return nil
    }
    
    /*
     *  Lists all instances of the current NSManagedObject with sort property
     *  @param managedContext:context for wanted database | as default, will get the standard Coredata shared instance for the App
     *  @param property: Name of the property to sort data
     *  @param ascending: Sets either the sort is *true for ascending* or *false for descending*
     */
    public static func list(withContext managedContext: NSManagedObjectContext = AwesomeDataAccess.sharedInstance.managedObjectContext, sortWith property:String, ascending:Bool) -> [NSManagedObject]{
        let sortDescriptor = NSSortDescriptor(key:property, ascending:ascending)
        return list(withContext: managedContext, sortDescriptor: sortDescriptor)
    }
    
    /*
     *  Sorts an NSArray with NSManagedObjects based on property
     *  @param array: array of NSManagedObjects
     *  @param property: Name of the property to sort data
     *  @param ascending: Sets either the sort is *true for ascending* or *false for descending*
     */
    public static func sortArray(array:NSArray, sortWith property:String, ascending:Bool) -> NSArray{
        let sortDescriptor = NSSortDescriptor(key:property, ascending:ascending)
        let sortDescriptors = [sortDescriptor]
        return array.sortedArrayUsingDescriptors(sortDescriptors)
    }
}

// MARK: - Json parsing

extension NSManagedObject {
    
    public class func parseDouble(jsonObject: [String: AnyObject], key: String) -> NSNumber {
        return NSNumber(double: AwesomeParser.doubleValue(jsonObject, key: key))
    }
    
    public class func parseInt(jsonObject: [String: AnyObject], key: String) -> NSNumber {
        return NSNumber(integer: AwesomeParser.intValue(jsonObject, key: key))
    }
    
    public class func parseBool(jsonObject: [String: AnyObject], key: String) -> NSNumber {
        return NSNumber(bool: AwesomeParser.boolValue(jsonObject, key: key))
    }
    
    public class func parseString(jsonObject: [String: AnyObject], key: String) -> String {
        return AwesomeParser.stringValue(jsonObject, key: key)
    }
    
    public class func parseDate(jsonObject: [String: AnyObject], key: String) -> NSDate? {
        return AwesomeParser.dateValue(jsonObject, key: key)
    }
    
}
