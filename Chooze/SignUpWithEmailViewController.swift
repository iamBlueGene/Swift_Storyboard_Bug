//
//  SignUpWithEmailViewController.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 9/27/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

class SignUpWithEmailViewController: UIViewController, UIAlertViewDelegate {

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
    

    @IBAction func doneButtonPressed(sender: AnyObject) {
        if !self.usernameTextField.text.isEmpty && !self.passwordTextField.text.isEmpty {
            EBParseService.signUpUser(usernameTextField.text.lowercaseString, password: passwordTextField.text, completionClosure: { (error) -> () in
                if error != nil {
                    ChoozeUtils.showError(error!)
                }
                else {
                    var alertView = UIAlertView(title: "Success", message: "You've succesfully registered", delegate: self, cancelButtonTitle: "OK")
                    alertView.show()
                }
            })
        }
        else {
            var alertView = UIAlertView(title: "Error", message: "Please fill in all the fields before pressing Sign Up", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
        }
    }
    
    // MARK: - AlertView Delegate
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

}
