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

var selectedItem = item(key: "0", name: "0", prompt: "0");

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
        selectedItem = items[indexPath.section][indexPath.row]
        performSegue(withIdentifier: "segueToPrompt", sender: self)
    }
}
