//
//  ResetPasswordViewController.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 9/27/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func resetPasswordButtonPressed(sender: AnyObject) {
        if !usernameTextField.text.isEmpty {
            EBParseService.resetPassword(usernameTextField.text.lowercaseString, completionClosure: { (error) -> () in
                if error != nil {
                    ChoozeUtils.showError(error!)
                } else {
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
            })

        }
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
