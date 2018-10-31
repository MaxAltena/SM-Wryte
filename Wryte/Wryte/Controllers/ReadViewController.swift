//
//  ReadViewController.swift
//  Wryte
//
//  Created by Max Altena on 11/10/2018.
//  Copyright © 2018 Max Altena. All rights reserved.
//

import UIKit
import FirebaseDatabase

struct item {
    var key: String
    var name: String
    var prompt: String
}

class ReadTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var promptText: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
}

class ReadViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    let sections = ["Noticable reads of the day", "Other interesting reads"]
    var items = [
        [item](),
        [item]()
    ]
    var counts = [String: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewLoadSetup()
    }
    func viewLoadSetup(){
        self.items = [
            [item](),
            [item]()
        ]
        self.counts = [String: Int]()
        ref = Database.database().reference()
        ref.child("stories").observeSingleEvent(of: .value, with: { (snapshot) in
            let stories = snapshot.value as? NSDictionary
            
            var promptsArray = [String]();
            for story in stories! {
                let value = story.value as? NSDictionary
                let prompt = value?["prompt"] as! String
                
                promptsArray.append(prompt)
            }
            promptsArray.forEach { self.counts[$0, default: 0] += 1 }
            print(self.counts)
        }) { (error) in
            print(error.localizedDescription)
        }
        ref.child("prompts").observeSingleEvent(of: .value, with: { (snapshot) in
            let prompts = snapshot.value as! NSDictionary
            for prompt in prompts {
                let value = prompt.value as! NSDictionary
                let key = prompt.key as! String
                var name = value["name"] as! String
                let prompt = value["prompt"] as! String
                let daily = value["daily"] as! Bool
                
                if(daily){
                    name = "Daily: \(name)"
                    let promptItem = item(key: key, name: name, prompt: prompt)
                    
                    let formatter = DateFormatter()
                    formatter.dateStyle = .short
                    formatter.dateFormat = "dd/MM/yyyy"
                    let todayDate = formatter.string(from: Date())
                    let yesterdayDate = formatter.string(from: Date().yesterday)
                    let date = value["date"] as! String
                    if(date == todayDate || date == yesterdayDate){
                        self.items[0].append(promptItem)
                    } else {
                        self.items[1].append(promptItem)
                    }
                } else {
                    name = "Prompt: \(name)"
                    let promptItem = item(key: key, name: name, prompt: prompt)
                    self.items[1].append(promptItem)
                }
            }
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
        return self.items[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "readCell", for: indexPath) as! ReadTableViewCell
        cell.nameLabel.text = items[indexPath.section][indexPath.row].name
        cell.promptText.text = items[indexPath.section][indexPath.row].prompt
        let count = counts[items[indexPath.section][indexPath.row].key] ?? 0
        cell.countLabel.text = "\(count) stories"
        cell.commentLabel.text = "0 comments"
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = items[indexPath.section][indexPath.row].key
        
        print("Selected row is \(key)")
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
