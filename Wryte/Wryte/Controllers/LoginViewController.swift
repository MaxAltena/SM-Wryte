//
//  ViewController.swift
//  Wryte
//
//  Created by Max Altena on 21/09/2018.
//  Copyright © 2018 Max Altena. All rights reserved.
//

import UIKit
import FirebaseDatabase

class LoginViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var roundedButton: RoundedButton!
    @IBOutlet weak var wbTop: UILabel!
    @IBOutlet weak var wbBottom: UILabel!
    @IBOutlet weak var usernameTextView: UITextView!
    
    @IBAction func getStartedPressed(_ sender: Any) {
        isLoggedIn = true
        username = createNewUsername()
        let defaults = UserDefaults.standard
        defaults.set(isLoggedIn, forKey: "isLoggedIn")
        defaults.set(username, forKey: "username")
        
        self.wbBottom.text = "\(username)!"
        self.usernameTextView.text = "We've missed you...\nGreat to have the one and only \(username) back on\nthe Wryters side!"
        
        UIView.animate(withDuration: 1, delay: 0.25, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.imageView.transform = self.imageView.transform.translatedBy(x: 0, y: -75)
            self.imageView.alpha = 0
            
            self.roundedButton.transform = self.roundedButton.transform.translatedBy(x: 0, y: 25)
            self.roundedButton.alpha = 0
        }) { (_) in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.wbTop.transform = CGAffineTransform(translationX: 0, y: 25)
                self.wbTop.alpha = 1
                
                self.wbBottom.transform = CGAffineTransform(translationX: 0, y: 25)
                self.wbBottom.alpha = 1
                
                self.usernameTextView.transform = CGAffineTransform(translationX: 0, y: -25)
                self.usernameTextView.alpha = 1
            }) {(_) in
                UIView.animate(withDuration: 0.25, delay: 5.25, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    self.wbTop.alpha = 0
                    self.wbBottom.alpha = 0
                    self.usernameTextView.alpha = 0
                }) {(_) in
                    self.performSegue(withIdentifier: "loginToMain", sender: self)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.roundedButton.alpha = 0
        self.wbTop.alpha = 0
        self.wbBottom.alpha = 0
        self.usernameTextView.alpha = 0
        
        animateShow()
    }
    
    func animateShow(){
        UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.imageView.transform = CGAffineTransform(translationX: 0, y: -75)
        })
        UIView.animate(withDuration: 0.75, delay: 0.75, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.roundedButton.alpha = 1
            self.roundedButton.transform = CGAffineTransform(translationX: 0, y: -25)
        })
    }
    
    func createNewUsername() -> String {
        let animals = ["Sheep", "Goat", "Elephant", "Hippo", "Tiger", "Lion", "Giraffe", "Fish", "Eagle", "Frog", "Horse", "Kiwi", "Koala", "Lizard", "Crab", "Lobster", "Parrot", "Pig", "Monkey", "Bear", "Seal", "Sloth", "Snake", "Squid", "Wolf", "Zebra"]
        let number1 = Int.random(in: 0 ..< 10)
        let number2 = Int.random(in: 0 ..< 10)
        let number3 = Int.random(in: 0 ..< 10)
        
        let username = animals.randomElement()! + String(number1) + String(number2) + String(number3)
        return username
    }
}
