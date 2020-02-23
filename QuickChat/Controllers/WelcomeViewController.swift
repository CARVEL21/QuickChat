//
//  WelcomeViewController.swift
//  QuickChat
//
//  Created by carlos on 18/02/20.
//  Copyright © 2020 Carlos Velasco. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nickName: UITextField!
    @IBOutlet weak var connect: UIButton!
    
    @IBAction func nickNameAction(_ sender: UIButton) {
        Auth.auth().signInAnonymously() { (authResult, error) in
          // ...
            if let e = error {
                print(e.localizedDescription)
            } else {
//                self.performSegue(withIdentifier: Constants.chatsegue, sender: self)
                guard let user = authResult?.user else { return }
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = self.nickName.text
                changeRequest?.commitChanges { (error) in
                  // ...
                }

            }

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = ""
        var charIndex = 0.0
        let titleText = Constants.appName
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }

    }
    
}
