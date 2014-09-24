//
//  ViewController.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 9/22/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    let k_smallScreenSizeConstant:CGFloat = 30
    let k_isSmallScreen = UIScreen.mainScreen().bounds.size.height == 480 ? true:false
    
    var shouldAllowBackButton = true
    
    @IBOutlet weak var faqButtonVerticalSpaceConstrain: NSLayoutConstraint!
    @IBOutlet weak var inviteButtonVerticalSpaceConstrain: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        isIphone4Model()
        let didRun = EBUserDefaults.sharedInstance.didRunApp()
        if didRun {
            // TODO: show intro view
        }
        
        if PFUser.currentUser() == nil {
            shouldAllowBackButton = false
            self.performSegueWithIdentifier("LogIn", sender: self)
        }

        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = true
        
     
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "LogIn" && !shouldAllowBackButton {
            let viewController = segue.destinationViewController as LogInOrRegisterViewController
            viewController.shouldHideBackButton = false
        }
        
    }
    
    // MARK: - IBActions
    
    @IBAction func inviteButtonPressed(sender: AnyObject) {
        if let currentUser = PFUser.currentUser() {
            
        }
        else {
            performSegueWithIdentifier("LogIn", sender: self)
        }
    }

    // MARK: - Helper Methods
    func isIphone4Model() {
        if k_isSmallScreen {
            self.faqButtonVerticalSpaceConstrain.constant -= k_smallScreenSizeConstant
            self.inviteButtonVerticalSpaceConstrain.constant -= k_smallScreenSizeConstant
        }
    }
    

}

