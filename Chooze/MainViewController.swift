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
     

        
        self.navigationController?.navigationBar.hidden = true

      
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
     
    }
    
    @IBAction func iapButtonPressed(sender: AnyObject) {
        
    }
    @IBAction func beginTestButtonPressed(sender: AnyObject) {
     
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
