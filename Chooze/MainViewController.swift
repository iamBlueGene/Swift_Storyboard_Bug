//
//  MainViewController.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 9/24/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let k_smallScreenSizeConstant:CGFloat = 30
    let k_isSmallScreen = UIScreen.mainScreen().bounds.size.height == 480 ? true:false
    weak var iapView: EBInAppPurchasesView?
    
    var shouldAllowBackButton = true
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var faqButtonVerticalSpaceConstrain: NSLayoutConstraint!
    @IBOutlet weak var inviteButtonVerticalSpaceConstrain: NSLayoutConstraint!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
 
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if PFUser.currentUser() == nil {
            shouldAllowBackButton = false
            performSegueWithIdentifier("LogIn", sender: nil)
            return
        }

        
        self.navigationController?.navigationBar.hidden = true

        if PFUser.currentUser() == nil {
            shouldAllowBackButton = false
            performSegueWithIdentifier("LogIn", sender: nil)
            return
        }
        isIphone4Model()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.hidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "LogIn" && !shouldAllowBackButton {
            segue.destinationViewController.navigationItem.hidesBackButton = true
            
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func inviteButtonPressed(sender: AnyObject) {
        if let currentUser = PFUser.currentUser() {
            EBFacebookService.sharedInstance.inviteFacebookFriends()
        }
        else {
            performSegueWithIdentifier("LogIn", sender: self)
        }
    }
    
    @IBAction func iapButtonPressed(sender: AnyObject) {
        if (iapView == nil) {
            var iapView2 = EBInAppPurchasesView()
            iapView2.center = self.view.center
            self.view.addSubview(iapView2)
            self.view.bringSubviewToFront(iapView2)
            self.iapView = iapView2
        }

    }
    @IBAction func beginTestButtonPressed(sender: AnyObject) {
        if let howManyTestsLeft :NSNumber = NSUserDefaults.standardUserDefaults().objectForKey("testsLeft") as? NSNumber {
            
            if howManyTestsLeft.intValue > 0 {
                self.performSegueWithIdentifier("EnterNames", sender: self)
            } else {
                var alertView = UIAlertView(title: "Error", message: "You don't have enough tests, please purchase more", delegate: self, cancelButtonTitle: "OK")
                alertView.show()
            }
        }
    }
    @IBAction func settingsButtonPressed(sender: AnyObject) {
        
    }
    // MARK: - Helper Methods
    
    func isIphone4Model() {
        if k_isSmallScreen {
            self.faqButtonVerticalSpaceConstrain.constant -= k_smallScreenSizeConstant
            self.inviteButtonVerticalSpaceConstrain.constant -= k_smallScreenSizeConstant
        }
    }
    


}
