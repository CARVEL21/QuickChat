//
//  RegisterViewController.swift
//  QuickChat
//
//  Created by carlos on 18/02/20.
//  Copyright © 2020 Carlos Velasco. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: Any) {
        if let email = emailTextfield.text, let password = passwordTextfield.text{
        
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    print(e.localizedDescription)
                }else{
                    self.performSegue(withIdentifier: Constants.registerSegue, sender: self)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    


}
