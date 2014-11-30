//
//  SignInWithEmailViewController.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 9/27/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

class SignInWithEmailViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextFieldView: UIView!
    @IBOutlet weak var passwordTextFieldView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        
        setTextFieldViewDesign(emailTextFieldView)
        setTextFieldViewDesign(passwordTextFieldView)

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.usernameTextField.becomeFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTextFieldViewDesign(textFieldView: UIView) {
        textFieldView.layer.borderWidth = 1
        textFieldView.layer.borderColor = UIColor.whiteColor().CGColor
        textFieldView.layer.cornerRadius = 5
    }

    @IBAction func signInButtonPressed(sender: AnyObject) {
        if !usernameTextField.text.isEmpty && !passwordTextField.text.isEmpty {
            EBParseService.logInToParse(usernameTextField.text.lowercaseString, password: passwordTextField.text, successBlock: { (success, parseError) -> () in
                if success {
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
                else {
                    if parseError!.code == 101 {
                        var alertView = UIAlertView(title: "Error", message: "Email/password combination is incorrect", delegate: nil, cancelButtonTitle: "OK")
                        alertView.show()
                    } else {
                        ChoozeUtils.showError(parseError!)  
                    }
                }
            })
        }
        else {
            
                var alertView = UIAlertView(title: "Error", message: "Please fill in all the fields before pressing Sign In", delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
            

        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == usernameTextField {
            self.passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            textField.resignFirstResponder()
            signInButtonPressed(self)
        }
        return true
    }

}
