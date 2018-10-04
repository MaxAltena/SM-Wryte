//
//  AppDelegate.swift
//  Wryte
//
//  Created by Max Altena on 21/09/2018.
//  Copyright © 2018 Max Altena. All rights reserved.
//

import UIKit
import Firebase

var isLoggedIn = "false"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        let defaults = UserDefaults.standard
        let defaultValue = ["isLoggedIn" : ""]
        defaults.register(defaults: defaultValue)
        
        if defaults.string(forKey: "isLoggedIn") == "" {
            defaults.set(isLoggedIn, forKey: "isLoggedIn")
        }
        
        let token = defaults.string(forKey: "isLoggedIn")
        isLoggedIn = token ?? "false"
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if isLoggedIn == "true" {
            let initialViewController: MainTabBarViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
            self.window?.rootViewController = initialViewController
        } else {
            let initialViewController: LoginViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.window?.rootViewController = initialViewController
        }
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        let defaults = UserDefaults.standard
        defaults.set(isLoggedIn, forKey: "isLoggedIn")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        let defaults = UserDefaults.standard
        defaults.set(isLoggedIn, forKey: "isLoggedIn")
    }


}

