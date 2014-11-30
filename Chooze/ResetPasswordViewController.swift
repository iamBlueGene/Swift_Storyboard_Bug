//
//  ResetPasswordViewController.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 9/27/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextFieldView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameTextField.delegate = self
        self.usernameTextField.becomeFirstResponder()
        
        setTextFieldViewDesign(emailTextFieldView)
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
    

    @IBAction func resetPasswordButtonPressed(sender: AnyObject) {
        if !usernameTextField.text.isEmpty {
            EBParseService.resetPassword(usernameTextField.text.lowercaseString, completionClosure: { (error) -> () in
                if error != nil {
                    ChoozeUtils.showError(error!)
                } else {
                    var alertView = UIAlertView(title: "Reset", message: "Reset email has been sent to your mail", delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                    
                    var prevVc:UIViewController = self.navigationController?.viewControllers[1] as UIViewController
                    self.navigationController?.popToViewController(prevVc, animated: true)
                }
            })

        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        resetPasswordButtonPressed(self)
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
