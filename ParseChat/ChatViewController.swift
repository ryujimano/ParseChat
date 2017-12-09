//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Ryuji Mano on 2/23/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var chatField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var users: [String] = []
    var messages: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
        
        if users[indexPath.row] == "" {
                cell.usernameLabel.text = "Anonymous"
        }
        else {
            cell.usernameLabel.text = users[indexPath.row]
        }
        cell.messageLabel.text = messages[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    

    @IBAction func sendButton(_ sender: Any) {
        let message = PFObject(className:"Message")
        message["text"] = chatField.text
        message["user"] = PFUser.current()
        message.saveInBackground {
            (success: Bool, error: Error?) -> Void in
            if (success) {
                self.chatField.text = ""
            } else {
                print(error)
            }
        }
    }
    
    @objc func onTimer() {
        let query = PFQuery(className:"Message")
        query.order(byDescending: "createdAt")
        query.includeKey("user")
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                self.users = []
                self.messages = []
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        self.users.append((object["user"] as? PFUser)?.username ?? "")
                        self.messages.append((object["text"] as? String) ?? "")
                    }
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.localizedDescription)")
            }
        }
    }

    @IBAction func logOut(_ sender: Any) {
        PFUser.logOut()
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
