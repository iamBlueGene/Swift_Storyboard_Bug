//
//  ResultsViewController.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 11/1/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit
import Social

class ResultsViewController: UIViewController {
    
    let kRPDIFFERENCES = 0.2;
    var backStatus = ""
    var prevViewController:UIViewController?

    
    @IBOutlet weak var bestNameLabel: UILabel!
    @IBOutlet weak var secondNameLabel: UILabel!
    @IBOutlet weak var thirdNameLabel: UILabel!
    @IBOutlet weak var shareToFacebookButton: UIButton!
    @IBOutlet weak var testsLeftLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonDesign(shareToFacebookButton)
        uploadResults()
        showResults()
        
        

        if let howManyTestsLeft :NSNumber = NSUserDefaults.standardUserDefaults().objectForKey("testsLeft") as? NSNumber {
            self.testsLeftLabel.text = "Tests Left:\(howManyTestsLeft)"
            var testsLeft = howManyTestsLeft.intValue
            testsLeft--
            testsLeft = testsLeft<0 ? 0:testsLeft
            var newNumber = NSNumber(int: testsLeft)
            
            NSUserDefaults.standardUserDefaults().setObject(newNumber, forKey: "testsLeft")
            NSUserDefaults.standardUserDefaults().synchronize()
        }

        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if backStatus != "Restart" {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
        })
        self.prevViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            //
        })
        self.prevViewController?.navigationController?.popToRootViewControllerAnimated(false)
        ChoozeUtils.sharedInstance.shouldGoToMenu = true
        }
    }
    
    func setButtonDesign(button :UIButton) {
        button.layer.cornerRadius = 40
        button.layer.borderColor = ChoozeUtils.rgbColor(77, greenValue: 206, blueValue: 230).CGColor
        button.layer.borderWidth = 1
    }
    
    
    func uploadResults() {
        
    }
    
    func showResults() {
        if let names = EBTestData.sharedInstance.getCalculatedNames() {
            var goodNames = names.filter{ $0.wordType == "Desired Names" }
            if goodNames.count == 1 {
                //WTF
            }
            if (goodNames[0].getResponseTime() - goodNames[1].getResponseTime()) > kRPDIFFERENCES {
                if goodNames.count == 2 {
                    self.bestNameLabel.text = goodNames[0].getWord()
                    self.bestNameLabel.alpha = 1.0
                    self.secondNameLabel.text =  self.secondNameLabel.text! + goodNames[1].getWord()
                    self.secondNameLabel.alpha = 1.0
                }
                else if goodNames.count > 2 {
                    self.bestNameLabel.text = goodNames[0].getWord()
                    self.bestNameLabel.alpha = 1.0
                    self.secondNameLabel.text =  self.secondNameLabel.text! + goodNames[1].getWord()
                     self.secondNameLabel.alpha = 1.0
                    self.thirdNameLabel.text = self.thirdNameLabel.text! + goodNames[2].getWord()
                    self.thirdNameLabel.hidden = false
                }
            }
            else {
                self.bestNameLabel.text = "It's a Tie"
                self.secondNameLabel.text =  self.secondNameLabel.text! + goodNames[0].getWord()
                self.thirdNameLabel.text = self.thirdNameLabel.text! + goodNames[1].getWord()
                self.thirdNameLabel.hidden = false
            }
        }

    }
    
    
    @IBAction func shareButtonPressed(sender: AnyObject) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            var facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            var textToShare = ""
            if bestNameLabel.text == "It's a Tie" {
                textToShare = "Looking for a name for my baby! I took a psychological test using Chooze app. I got a tie: 1.\(bestNameLabel.text!) 2.\(secondNameLabel.text!)  What do you think?   Link to appstore"
            }
            else {
                textToShare = "Looking for a name for my baby! I took a psychological test using Chooze app. Here's the ranking I got: 1.\(bestNameLabel.text!) 2.\(secondNameLabel.text!)  What do you think?   Link to appstore"
                 //textToShare = "I did a psychological test using the 'Chooze' App and this is the name I should 'Chooze' : " + self.bestNameLabel.text!
            }

            facebookSheet.setInitialText(textToShare)
            self.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func restartTestButtonPressed(sender: AnyObject) {
        if let howManyTestsLeft :NSNumber = NSUserDefaults.standardUserDefaults().objectForKey("testsLeft") as? NSNumber {
            
            if howManyTestsLeft.intValue > 0 {
                backStatus = "Restart"
                var numberOfNavigationControllers = self.navigationController?.viewControllers.count
                numberOfNavigationControllers = numberOfNavigationControllers! - 1
                var prevVc:UIViewController = self.navigationController?.viewControllers[0] as UIViewController
                self.navigationController?.popToViewController(prevVc, animated: true)
                //     self.dismissViewControllerAnimated(true, completion: { () -> Void in
                //
                //})
                if let prevVC = prevViewController as? TestViewController {
                    prevVC.startTest()
                }
            } else {
                var alertView = UIAlertView(title: "Error", message: "You don't have enough tests, please purchase more", delegate: self, cancelButtonTitle: "OK" )
                alertView.show()
            }
        }

    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
