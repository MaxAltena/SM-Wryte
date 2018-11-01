//
//  PromptViewController.swift
//  Wryte
//
//  Created by Max Altena on 31/10/2018.
//  Copyright © 2018 Max Altena. All rights reserved.
//

import UIKit
import FirebaseDatabase


struct story {
    var prompt: String
    var story: String
    var user: String
}

var selectedStory = [String: String]()

class PromptTableViewCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var storyText: UITextView!
}

class PromptViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    let sections = ["\(selectedItem.name)", "Stories"]
    var items = [
        [[String: String]()],
        [[String: String]()]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        ref.child("stories").observeSingleEvent(of: .value, with: { (snapshot) in
            let stories = snapshot.value as? NSDictionary
            self.items[1].remove(at: 0)
            for story in stories! {
                let value = story.value as? NSDictionary
                let prompt = value?["prompt"] as! String
                if(selectedItem.key == prompt){
                    let newStory = ["story": value?["story"], "user": value?["user"]]
                    self.items[1].append(newStory as! [String : String]);
                }
            }
            print(self.items[1])
            
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(rgb: 0xFFFFFF)
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor(rgb: 0x22585E)
        header.textLabel?.font = UIFont(name: "Merriweather-Bold", size: 20.0)
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.items[section] as AnyObject).count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "promptCell", for: indexPath) as! PromptTableViewCell
        if(indexPath.section == 0){
            cell.usernameLabel.text = selectedItem.name
            cell.storyText.text = selectedItem.prompt
            return cell
        } else {
            cell.usernameLabel.text = items[indexPath.section][indexPath.row]["user"]
            cell.storyText.text = items[indexPath.section][indexPath.row]["story"]
            return cell
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 1){
            selectedStory = items[indexPath.section][indexPath.row]
            print(selectedStory)
        }
        
    }

}


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
}
