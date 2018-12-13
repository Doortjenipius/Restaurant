//
//  AppDelegate.swift
//  Restaurant
//
//  Created by doortje on 03/12/2018.
//  Copyright © 2018 Doortje. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var orderTabBarItem: UITabBarItem!
    var window: UIWindow?

// Rode notificatie button die bijhoudt hoeveel items er worden besteld.
    @objc func updateOrderBadge() {
        switch MenuController.shared.order.menuItems.count {
        case 0:
            orderTabBarItem.badgeValue = nil
        case let count:
            orderTabBarItem.badgeValue = String(count)
        }
    }
    

        func application(_ application: UIApplication,
                         didFinishLaunchingWithOptions launchOptions:
            [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            let temporaryDirectory = NSTemporaryDirectory()
            let urlCache = URLCache(memoryCapacity: 25_000_000,
                                    diskCapacity: 50_000_000, diskPath: temporaryDirectory)
            URLCache.shared = urlCache
            
            NotificationCenter.default.addObserver(self, selector:
                #selector(updateOrderBadge), name:
                MenuController.orderUpdatedNotification, object: nil)
            
            orderTabBarItem = (self.window!.rootViewController! as!
                UITabBarController).viewControllers![1].tabBarItem
// Order badge wordt geupdate. 
            updateOrderBadge()
            
            return true
        }
// Order laden gebeurt vanuit de app delegate.
    func application(_ application: UIApplication,
                     willFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        MenuController.shared.loadOrder()
        MenuController.shared.loadItems()
        MenuController.shared.loadRemoteData()
        
        return true
    }

// Slaat juiste data over de app op.
    func application(_ application: UIApplication,
                        shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }

// Checkt of de app beschikt over de juiste elementen om hem opnieuw te restoren. 
    func application(_ application: UIApplication,
                     shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

// Order wordt opgeslagen als de app naar de Background gaat.
    func applicationDidEnterBackground(_ application:
        UIApplication) {
        MenuController.shared.saveOrder()
        MenuController.shared.saveItems()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

