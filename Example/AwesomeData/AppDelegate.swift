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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //TODO: To configure which should be the standard CoreData file, simply call
        AwesomeData.setDatabase("AwesomeDataDemo")
        //AwesomeData.setDatabase("AwesomeDataDemo", groupName: "group.com.iOSWizards.test")
        AwesomeData.showLogs = true
        
        //Configure cache
        AwesomeCacheManager.configureCache()
        
        return true
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        //Clears cache
        AwesomeCacheManager.clearCache()
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        //TODO: Save CoreData Context on terminate
        AwesomeData.saveContext()
    }

}

