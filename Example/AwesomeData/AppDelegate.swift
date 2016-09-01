//
//  AppDelegate.swift
//  AwesomeDataDemo
//
//  Created by Evandro Harrison Hoffmann on 24/08/2016.
//  Copyright © 2016 It's Day Off. All rights reserved.
//

import UIKit
import AwesomeData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //TODO: To configure which should be the standard CoreData file, simply call
        AwesomeData.setDatabase("AwesomeDataDemo")
        AwesomeData.showLogs = true
        
        //Configure cache
        AwesomeCacheManager.configureCache()
        
        return true
    }
    
    func applicationDidReceiveMemoryWarning(application: UIApplication) {
        //Clears cache
        AwesomeCacheManager.clearCache()
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
        //TODO: Save CoreData Context on terminate
        AwesomeData.saveContext()
    }

}

