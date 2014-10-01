//
//  SignInWithEmailViewController.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 9/27/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

class SignInWithEmailViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signInButtonPressed(sender: AnyObject) {
        if !usernameTextField.text.isEmpty && !passwordTextField.text.isEmpty {
            EBParseService.logInToParse(usernameTextField.text.lowercaseString, password: passwordTextField.text, successBlock: { (success, parseError) -> () in
                if success {
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
                else {
                    ChoozeUtils.showError(parseError!)
                }
            })
        }
        else {
            var alertView = UIAlertView(title: "Error", message: "Please fill in all the fields before pressing Sign In", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
        }
        
    }

}
