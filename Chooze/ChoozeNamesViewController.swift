//
//  ChoozeNamesViewController.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 9/30/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

class ChoozeNamesViewController: UIViewController {
    
    @IBOutlet weak var desiredNamesDescription: UILabel!
    @IBOutlet weak var undesiredNamesDescription: UILabel!
    @IBOutlet weak var step1Label: UILabel!
    @IBOutlet weak var step2Label: UILabel!
    @IBOutlet weak var tagListView: EBTagListView!
    @IBOutlet weak var continueView: UIView!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    
    private var unavilableNames:Array<String>?
    private var stepNumber = 1
    private var onceToken : dispatch_once_t = 0
    private var tagListViewStatus = EBTagListStatus.Normal
    
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
        if stepNumber == 2 {
            makeStep2()
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
                // start test 
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
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
