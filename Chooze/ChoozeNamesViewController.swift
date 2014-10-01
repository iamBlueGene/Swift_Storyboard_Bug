//
//  ChoozeNamesViewController.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 9/30/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

class ChoozeNamesViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var desiredNamesDescription: UILabel!
    @IBOutlet weak var undesiredNamesDescription: UILabel!
    @IBOutlet weak var step1Label: UILabel!
    @IBOutlet weak var step2Label: UILabel!
    @IBOutlet weak var tagListView: EBTagListView!
    @IBOutlet weak var continueView: UIView!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var continueViewVerticalSpaceConstraint: NSLayoutConstraint!
    
    //  MARK: - Variables
    
    private var unavilableNames:Array<String>?
    private var stepNumber = 1
    private var onceToken : dispatch_once_t = 0
    private var tagListViewStatus = EBTagListStatus.Normal
    private var isKeyboardUp = false
    
    // MARK: - View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
        
        self.tagListView.updateNamesToHandler()
        if stepNumber == 2 {
            makeStep2()
        }
        else if stepNumber == 1
        {
            makeStep1()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        dispatch_once(&onceToken) {
            self.tagListView.startWritingNames()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "NextStepSegue" {
            if stepNumber == 1 {
                var viewController = segue.destinationViewController as ChoozeNamesViewController
                viewController.stepNumber = 2
                viewController.unavilableNames = EBTestNamesDataHandler.shardInstance.getCurrentNames()
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return ((sender as NSObject) == self)
    }
    
    // MARK: - IBActions
    
    @IBAction func continueButtonPressed(sender: AnyObject) {
        if stepNumber == 2 {
            if EBTestNamesDataHandler.shardInstance.canStartTest() {
                self.performSegueWithIdentifier("BeginTest", sender: self)
            }
        }
        else {
            if EBTestNamesDataHandler.shardInstance.canGoToStepTwo() {
            self.performSegueWithIdentifier("NextStepSegue", sender: self)
            }
        }
    }
    
    @IBAction func editButtonPressed(sender: AnyObject) {
        if tagListView.canDeleteNames() {
            if tagListViewStatus == EBTagListStatus.Normal {
                tagListView.setStatus(EBTagListStatus.Editing)
                setTagListViewStatusEditing()
            }
            else if tagListViewStatus == EBTagListStatus.Editing {
                tagListView.setStatus(EBTagListStatus.Normal)
                setTagListViewStatusNoraml()
            }
        }
        else {
            let alertView = UIAlertView(title: "Error", message: "Can not edit while adding names", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
        }
    }
    
    // MARK: - Methods
    
    private func makeStep2() {
        self.step1Label.hidden =  true
        self.step2Label.hidden = false
        self.desiredNamesDescription.hidden = true
        self.undesiredNamesDescription.hidden = false
        EBTestNamesDataHandler.shardInstance.setUnavilableNames(self.unavilableNames!)
    }
    
    private func makeStep1() {
        EBTestNamesDataHandler.shardInstance.setUnavilableNames(Array<String>())
    }
    
    private func setTagListViewStatusEditing() {
        //self.editButton.setTitle("Done", forState: UIControlState.Normal)
        self.editButton.title = "Done"
        self.tagListViewStatus = EBTagListStatus.Editing
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.deleteView.alpha = 1.0;
            self.continueView.alpha = 0.0;
        })
    }
    
    private func setTagListViewStatusNoraml() {
        //self.editButton.setTitle("Edit", forState: UIControlState.Normal)
        self.editButton.title = "Edit"
        self.tagListViewStatus = EBTagListStatus.Normal
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.deleteView.alpha = 0.0;
            self.continueView.alpha = 1.0;
        })
    }
    
    // MARK: - Keyboard Notifications
    
    private func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChange:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    func keyboardWillShow(notification : NSNotification) {
        isKeyboardUp = true
    }
    
    func keyboardWillHide(notification : NSNotification) {
        isKeyboardUp = false
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.continueViewVerticalSpaceConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    func keyboardWillChange(notification : NSNotification) {
        if let keyboardInfo = notification.userInfo {
            if let keyboardFrameBegin: AnyObject = keyboardInfo[UIKeyboardFrameEndUserInfoKey] {
                let keyboardFrameBeginRect = keyboardFrameBegin.CGRectValue()
                self.continueViewVerticalSpaceConstraint.constant = keyboardFrameBeginRect.size.height - 64 ;
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
}
