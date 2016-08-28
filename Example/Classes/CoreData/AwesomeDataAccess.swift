//
//  DataAccess.swift
//  AwesomeData
//
//  Created by Evandro Harrison Hoffmann on 10/19/15.
//  Copyright © 2015 It's Day Off. All rights reserved.
//

import UIKit
import CoreData

//let GROUPNAME = "group.com.itsdayoff.EmagrecerDeVez.Documents"
//let DATABASE_NAME = "PrevisaoDoTempo"
//let DATABASE_NAME_SQLITE = "\(DATABASE_NAME).sqlite"

public class AwesomeDataAccess: NSObject {
    
    static public var sharedInstance = AwesomeDataAccess()
    
    var databaseName: String!
    var databaseNameSqlite: String!
    
    override init(){
        super.init()
    }
    
    init(databaseName: String) {
        super.init()
        setDatabase(databaseName)
    }
    
    public func setDatabase(name: String){
        databaseName = name
        databaseNameSqlite = "\(databaseName).sqlite"
    }
    
    // MARK: - Local Core Data stack
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
        }()
    
    // MARK: - Core Data stack
    
    public lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
        }()
    
    public lazy var managedObjectModel: NSManagedObjectModel = {
        if self.databaseName == nil {
            NSLog("You forgot setting up the database name")
            abort()
        }
        
        let modelURL = NSBundle.mainBundle().URLForResource(self.databaseName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    public lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    public func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}
