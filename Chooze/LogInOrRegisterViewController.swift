//
//  LogInOrRegisterViewController.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 9/23/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

class LogInOrRegisterViewController: UIViewController {
    
    var shouldHideBackButton = true

    override func viewDidLoad() {
        super.viewDidLoad()
       // performSegueWithIdentifier("test", sender: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       // self.navigationController?.navigationBar.hidden = false
       // navigationItem.hidesBackButton = shouldHideBackButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
