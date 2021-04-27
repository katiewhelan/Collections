//
//  ViewController.swift
//  CollectIt
//
//  Created by Kathryn Whelan on 2/21/21.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func LogInPressed(_ sender: UIButton) {
        if let email = emailTextField?.text, let password = passwordTextField?.text {
            
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print("error logging in user \(e)")
                } else {
                    self.performSegue(withIdentifier: "TabBar", sender: self)
                }
            }
            
        }
    }
}
