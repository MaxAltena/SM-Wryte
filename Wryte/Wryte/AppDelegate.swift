//
//  AppDelegate.swift
//  Wryte
//
//  Created by Max Altena on 21/09/2018.
//  Copyright © 2018 Max Altena. All rights reserved.
//

import UIKit
import Firebase

var isLoggedIn = false
var username = ""
var todayPromptText = ""
var todayPromptID = ""
var dailyDone = false
var ref: DatabaseReference!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        let defaults = UserDefaults.standard
        let defaultValues = ["isLoggedIn" : false, "username" : "", "dailyDone": false, "todayPromptID": ""] as [String : Any]
        defaults.register(defaults: defaultValues)
        
        if defaults.bool(forKey: "isLoggedIn") == false {
            defaults.set(isLoggedIn, forKey: "isLoggedIn")
        }
        
        if defaults.string(forKey: "username") == "" {
            defaults.set(username, forKey: "username")
        }
        
        if defaults.bool(forKey: "dailyDone") == false {
            defaults.set(dailyDone, forKey: "dailyDone")
        }
        
        if defaults.string(forKey: "todayPromptID") == "" {
            defaults.set(todayPromptID, forKey: "todayPromptID")
        }
        
        let token_isLoggedIn = defaults.bool(forKey: "isLoggedIn")
        isLoggedIn = token_isLoggedIn
        
        let token_username = defaults.string(forKey: "username")
        username = token_username ?? ""
        
        let token_dailyDone = defaults.bool(forKey: "dailyDone")
        dailyDone = token_dailyDone
        
        let token_todayPromptID = defaults.string(forKey: "todayPromptID")
        todayPromptID = token_todayPromptID ?? ""
        
        getDailyPrompt()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if(isLoggedIn) {
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
        defaults.set(username, forKey: "username")
        defaults.set(dailyDone, forKey: "dailyDone")
        defaults.set(todayPromptID, forKey: "todayPromptID")
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
        defaults.set(username, forKey: "username")
        defaults.set(dailyDone, forKey: "dailyDone")
        defaults.set(todayPromptID, forKey: "todayPromptID")
    }

    func getDailyPrompt() {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "dd/MM/yyyy"
        let todayDate = formatter.string(from: Date())
        
        ref = Database.database().reference()
        ref.child("prompts").observeSingleEvent(of: .value, with: { (snapshot) in
            let prompts = snapshot.value as? NSDictionary
            
            for prompt in prompts! {
                let value = prompt.value as? NSDictionary
                let date = value?["date"] as? String
                let daily = value?["daily"] as? Bool
                if(date == todayDate && daily == true){
                    todayPromptText = value?["prompt"] as? String ?? "No daily prompt today"
                    
                    let defaults = UserDefaults.standard
                    if(dailyDone && todayPromptID == prompt.key as! String) {
                        dailyDone = false
                        todayPromptID = prompt.key as! String
                        defaults.set(dailyDone, forKey: "dailyDone")
                        defaults.set(todayPromptID, forKey: "todayPromptID")
                    } else {
                        todayPromptID = prompt.key as! String
                        defaults.set(dailyDone, forKey: "dailyDone")
                        defaults.set(todayPromptID, forKey: "todayPromptID")
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
