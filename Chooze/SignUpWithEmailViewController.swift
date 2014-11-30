//
//  SignUpWithEmailViewController.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 9/27/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

class SignUpWithEmailViewController: UIViewController, UIAlertViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var emailTextFieldView: UIView!
    @IBOutlet weak var passwordTextFieldView: UIView!
    @IBOutlet weak var confirmPasswordTextFieldView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
        
        setTextFieldViewDesign(emailTextFieldView)
        setTextFieldViewDesign(passwordTextFieldView)
        setTextFieldViewDesign(confirmPasswordTextFieldView)

        // Do any additional setup after loading the view.
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
    

    @IBAction func doneButtonPressed(sender: AnyObject) {
        if !self.usernameTextField.text.isEmpty && !self.passwordTextField.text.isEmpty && passwordTextField.text == confirmPasswordTextField.text {
            self.usernameTextField.resignFirstResponder()
            self.passwordTextField.resignFirstResponder()
            self.confirmPasswordTextField.resignFirstResponder()
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
            if !passwordTextField.text.isEmpty && passwordTextField.text != confirmPasswordTextField.text {
                var alertView = UIAlertView(title: "Error", message: "Passwords don't match", delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
            } else {
                var alertView = UIAlertView(title: "Error", message: "Please fill in all the fields before pressing Sign Up", delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
            }
        }
    }
    
    // MARK: - AlertView Delegate
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == usernameTextField {
            self.passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        }
        else if textField == confirmPasswordTextField {
            textField.resignFirstResponder()
            doneButtonPressed(self)
        }
        return true
    }

}
