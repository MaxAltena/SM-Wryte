//
//  ViewController.swift
//  Wryte
//
//  Created by Max Altena on 21/09/2018.
//  Copyright © 2018 Max Altena. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBAction func getStartedPressed(_ sender: Any) {
        isLoggedIn = "true"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animateShow()
    }
    
    func animateShow(){
    }
}
