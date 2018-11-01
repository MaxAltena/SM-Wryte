//
//  SettingsViewController.swift
//  Wryte
//
//  Created by Max Altena on 25/10/2018.
//  Copyright © 2018 Max Altena. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBAction func logoutPressed(_ sender: Any) {
        isLoggedIn = false
        dailyDone = false
        let defaults = UserDefaults.standard
        defaults.set(isLoggedIn, forKey: "isLoggedIn")
        defaults.set(dailyDone, forKey: "dailyDone")
    }
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLabel.text = username
    }
}
