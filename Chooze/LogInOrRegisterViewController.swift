//
//  LogInOrRegisterViewController.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 9/23/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

class LogInOrRegisterViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInWithFacebookButtonPressed(sender: AnyObject) {
        EBFacebookService.sharedInstance.signInWithFacebook { (success,error) -> () in
            if success {
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
            else {
                if error != nil {
                    ChoozeUtils.showError(error!)
                }
            }
        }
    }
    
    @IBAction func watchIntroButtonPressed(sender: AnyObject) {
        var introView:EBIntroView? = EBIntroView()
        introView!.show({() ->() in
            introView = nil
            }
        )

    }
    
}
