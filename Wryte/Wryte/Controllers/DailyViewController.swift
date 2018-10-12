//
//  DailyViewController.swift
//  Wryte
//
//  Created by Max Altena on 04/10/2018.
//  Copyright © 2018 Max Altena. All rights reserved.
//

import UIKit
import FirebaseDatabase

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
        
        doneLabel.alpha = 0
        doneText.alpha = 0
        doneReadButton.alpha = 0
        
        dailyPrompt.text = todayPromptText
        
        textView.delegate = self
        textView.text = "Start writing your story..."
        textView.textColor = UIColor.lightGray
    }
    
    @IBAction func publishClicked(_ sender: Any) {
        self.view.endEditing(true)
        move(textView, moveDistance: -175, up: false)
        
        let text = textView.text
        ref = Database.database().reference()
        ref.child("stories").childByAutoId().setValue(["prompt": todayPromptID as String, "story": text! as String , "user": username as String])
        
        dailyDone = "true"
        self.doneText.text = "You have written a nice story there \(username)!\nGet ready to read some stories made by fellow Wryters."
        
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
}

extension DailyViewController: UITextViewDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
        move(textView, moveDistance: -175, up: false)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
        move(textView, moveDistance: -175, up: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Start writing your story..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func move(_ textView: UITextView, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
}
