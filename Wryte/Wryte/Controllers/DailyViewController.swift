//
//  DailyViewController.swift
//  Wryte
//
//  Created by Max Altena on 04/10/2018.
//  Copyright © 2018 Max Altena. All rights reserved.
//

import UIKit

class DailyViewController: UIViewController {
    @IBOutlet weak var dailyPrompt: UITextView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var publishButton: RoundedButton!

    
    let dailyPrompts = ["Lorem ipsum 0", "Lorem ipsum 1", "Lorem ipsum 2", "Lorem ipsum 3", "Lorem ipsum 4", "Lorem ipsum 5", "Lorem ipsum 6", "Lorem ipsum 7"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "dd/MM/yyyy"
        let dateToday = formatter.string(from: Date())
        
        dailyPrompt.text = getDailyPrompt(todaysDate: dateToday)
        
        textView.delegate = self
        textView.text = "Start writing your story..."
        textView.textColor = UIColor.lightGray
    }
    
    func getDailyPrompt(todaysDate: String) -> String {
        var str : String
        
        switch(todaysDate){
        case "04/10/2018":
            str = dailyPrompts[0]
            break;
        case "05/10/2018":
            str = dailyPrompts[1]
            break;
        case "06/10/2018":
            str = dailyPrompts[2]
            break;
        case "07/10/2018":
            str = dailyPrompts[3]
            break;
        case "08/10/2018":
            str = dailyPrompts[4]
            break;
        case "09/10/2018":
            str = dailyPrompts[5]
            break;
        case "10/10/2018":
            str = dailyPrompts[6]
            break;
        case "11/10/2018":
            str = dailyPrompts[7]
            break;
        default:
            str = "Seems like your date isn't working"
            break;
        }
        
        return str;
    }
}

extension DailyViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
        }
    }
}
