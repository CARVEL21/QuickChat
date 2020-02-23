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
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title = Constants.appName
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        
        loadMessages()

    }
    func loadMessages() {
        
        db.collection(Constants.FStore.collectionName).order(by: Constants.FStore.dateField).addSnapshotListener { (querySnapshot, error) in
            
            self.messages = []
            
            if let e = error{
                print("hubo un problema en racabar la data de firestore \(e)")
            }else{
                if let snapshotDocuments = querySnapshot?.documents{
                    for doc in snapshotDocuments{
                        //print(doc.data())
                        let data = doc.data()
                        if let messageSender = data[Constants.FStore.senderField] as? String, let messageBody =
                                data[Constants.FStore.bodyField] as? String{
                                let newMessage = Message(sender: messageSender, body: messageBody)
                                self.messages.append(newMessage)
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                }
                        }
                    }
                }
            }
        }
    }
    


    @IBAction func sendPressed(_ sender: Any) {
        if let messageBody = messageTextfield.text, let messgeSender = Auth.auth().currentUser?.email{
            db.collection(Constants.FStore.collectionName).addDocument(data: [
                Constants.FStore.senderField: messgeSender,
                Constants.FStore.bodyField: messageBody,
                Constants.FStore.dateField:Date().timeIntervalSince1970
            ]){(error) in
                if let e = error{
                    print("hubo un problema guardando la data en firestore, \(e)")
                }else{
                    print("Se guardo exitosamente la data.")
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                }
                
            }
        }
        
        
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
        
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
            as! MessageCell
        
        let messageSender = message.sender
        let range: Range<String.Index> = messageSender.range(of: "@")!
        let indexEnd: Int = messageSender.distance(from: messageSender.startIndex, to: range.lowerBound)
        let index: String.Index = messageSender.index(messageSender.startIndex, offsetBy: indexEnd )
        let nameSender = String(messageSender[..<index])
        cell.label.text = message.body
        cell.nameLabel.text = nameSender
        
        //mensaje de usuario actual
        if message.sender == Auth.auth().currentUser?.email{
            cell.leftImageView.isHidden = true
            cell.nameLabel.isHidden = true
            cell.nameBubble.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.blue)
        }else{
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = true
            cell.nameLabel.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.lightRed)
        }

        return cell
    }
}


