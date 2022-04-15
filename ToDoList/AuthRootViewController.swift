//
//  AuthRootViewController.swift
//  ToDoList
//
//  Created by Chance Rohda on 4/15/22.
//

import UIKit

class AuthRootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonDidTouch(_ sender: Any) {
        performSegue(withIdentifier: "LoginSegue", sender: nil)
    }
    
    @IBAction func CreateAccountButtonDidTouch(_ sender: Any) {
        performSegue(withIdentifier: "CreateAccountSegue", sender: nil)
    }
    
}
