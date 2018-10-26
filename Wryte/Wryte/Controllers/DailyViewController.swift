//
//  DailyViewController.swift
//  Wryte
//
//  Created by Max Altena on 04/10/2018.
//  Copyright © 2018 Max Altena. All rights reserved.
//

import UIKit
import FirebaseDatabase

var keyboardActive = false;

class DailyViewController: UIViewController {
    @IBOutlet weak var topText: UILabel!
    @IBOutlet weak var dailyPrompt: UITextView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var publishButton: RoundedButton!
    @IBOutlet weak var doneLabel: UILabel!
    @IBOutlet weak var doneText: UITextView!
    @IBOutlet weak var doneReadButton: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewLoadSetup()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewLoadSetup()
    }
    func viewLoadSetup(){
        doneLabel.alpha = 0
        doneText.alpha = 0
        doneReadButton.alpha = 0
        textView.delegate = self
        textView.text = "Start writing your story..."
        textView.textColor = UIColor.lightGray
        
        if(todayPromptText.isEmpty){
            getDailyPrompt()
        } else {
            dailyPrompt.text = todayPromptText
        }
        
        if(dailyDone){
            self.doneText.text = "You have already written a nice story today \(username)!\nGet ready to read some stories made by fellow Wryters."
            publishButton.isEnabled = false
            moveStuff()
        }
    }
    func moveStuff(){
        UIView.animate(withDuration: 0.75, delay: 0.25, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.topText.transform = CGAffineTransform(translationX: 0, y: -25)
            self.topText.alpha = 0
            
            self.dailyPrompt.transform = CGAffineTransform(translationX: 0, y: -25)
            self.dailyPrompt.alpha = 0
            
            self.textView.transform = CGAffineTransform(translationX: 0, y: 25)
            self.textView.alpha = 0
            
            self.publishButton.transform = CGAffineTransform(translationX: 0, y: 25)
            self.publishButton.alpha = 0
        }) { (_) in
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.doneLabel.transform = CGAffineTransform(translationX: 0, y: 25)
                self.doneLabel.alpha = 1
                
                self.doneText.transform = CGAffineTransform(translationX: 0, y: -25)
                self.doneText.alpha = 1
                
                self.doneReadButton.transform = CGAffineTransform(translationX: 0, y: -25)
                self.doneReadButton.alpha = 1
            })
        }
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
                    
                    if(dailyDone && todayPromptID == prompt.key as! String) {
                        dailyDone = false
                        todayPromptID = prompt.key as! String
                        let defaults = UserDefaults.standard
                        defaults.set(dailyDone, forKey: "dailyDone")
                        defaults.set(todayPromptID, forKey: "todayPromptID")
                    } else {
                        todayPromptID = prompt.key as! String
                        let defaults = UserDefaults.standard
                        defaults.set(todayPromptID, forKey: "todayPromptID")
                    }
                }
            }
            self.dailyPrompt.text = todayPromptText
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func onReadClick(_ sender: Any) {
        tabBarController?.selectedIndex = 2
    }
    
    @IBAction func publishClicked(_ sender: Any) {
        if(keyboardActive){
            self.view.endEditing(true)
            keyboardActive = false;
            move(active: keyboardActive)
        }
        
        let text = textView.text
        
        if(text?.isEmpty == false && text != "Start writing your story...") {
            ref = Database.database().reference()
            ref.child("stories").childByAutoId().setValue(["prompt": todayPromptID as String, "story": text! as String , "user": username as String])
            
            dailyDone = true
            let defaults = UserDefaults.standard
            defaults.set(dailyDone, forKey: "dailyDone")
            self.doneText.text = "You have written a nice story there \(username)!\nGet ready to read some stories made by fellow Wryters."
            moveStuff()
        }
    }
}

extension DailyViewController: UITextViewDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(keyboardActive){
            self.view.endEditing(true)
            keyboardActive = false;
            move(active: keyboardActive)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        keyboardActive = true;
        move(active: keyboardActive)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Start writing your story..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func move(active: Bool) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            if(active){
                self.topText.transform = CGAffineTransform(translationX: 0, y: -150)
                self.dailyPrompt.transform = CGAffineTransform(translationX: 0, y: -123)
                self.textView.transform = CGAffineTransform(translationX: 0, y: -140)
                self.publishButton.transform = CGAffineTransform(translationX: 0, y: -175)
            } else {
                self.topText.transform = CGAffineTransform(translationX: 0, y: 0)
                self.dailyPrompt.transform = CGAffineTransform(translationX: 0, y: 0)
                self.textView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.publishButton.transform = CGAffineTransform(translationX: 0, y: 0)
            }
        })
    }
}
