//
//  ProfileViewController.swift
//  Wryte
//
//  Created by Max Altena on 21/09/2018.
//  Copyright © 2018 Max Altena. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBAction func logoutPressed(_ sender: Any) {
        isLoggedIn = "false"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
