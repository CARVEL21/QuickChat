//
//  ChatViewController.swift
//  QuickChat
//
//  Created by carlos on 18/02/20.
//  Copyright © 2020 Carlos Velasco. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    var messages: [Message] = [
        Message(sender: "carlos@me.com", body: "hola, como estas"),
        Message(sender: "Shirley@me.com", body: "hola, muy bien")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title = Constants.appName
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)

    }

    @IBAction func sendPressed(_ sender: Any) {
    }
    
    @IBAction func LogOutPressed(_ sender: Any) {

        do {
          try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
}
// extend nuestro chat view controller para que pueda adoptar el protocolo UITableViewDataSource quiere decir que cuando nuestro table view cargue va a hacer una solicitud de data
extension ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
            as! MessageCell
        cell.label.text = messages[indexPath.row].body
        return cell
    }
}


