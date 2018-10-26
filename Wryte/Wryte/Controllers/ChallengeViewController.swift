//
//  ChallengeViewController.swift
//  Wryte
//
//  Created by Max Altena on 25/10/2018.
//  Copyright © 2018 Max Altena. All rights reserved.
//

import UIKit

class ChallengeViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameLabel.text = "Sorry, \(username)!"
    }
}
