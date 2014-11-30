//
//  TestViewController.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 10/1/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

@objc(TestViewController) class TestViewController: UIViewController, EBTestDataDelegate, EBTestMenuViewDeleagte, EBInstructionsDelegate, EBBlockDelegate{
    
    var desiredNams = Array<String>()
    var undesiredNames = Array<String>()
    var currentBlock = 1
    var startTime:CFTimeInterval?
    var totalTimeSoFar:CFTimeInterval = 0
    var didShowFirstMistake = false
    var firstWord:String?
    var didFinishLoadingData = false
    private var startTestTimer:NSTimer?
    var prevViewController:UIViewController?
    var waitingIndicator:EBWaitingIndicator?
    var timer:NSTimer?
    
    @IBOutlet weak var leftLabel1: UILabel!
//    @IBOutlet weak var leftLabel2: UILabel!
    @IBOutlet weak var rightLabel1: UILabel!
    //@IBOutlet weak var rightLabel2: UILabel!
    @IBOutlet weak var leftLine: UIView!
    @IBOutlet weak var rightLine: UIView!
    @IBOutlet weak var selectCategoryExplenationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var leftPartButton: UIButton!
    @IBOutlet weak var rightPartButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var rotateScreenImage: UIImageView!
    
    

    @IBOutlet var leftLabel2: UILabel!
    @IBOutlet var rightLabel2: UILabel!

    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChange", name: UIDeviceOrientationDidChangeNotification, object: nil)
        //
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if ChoozeUtils.sharedInstance.shouldGoToMenu {
            navigationController?.popToRootViewControllerAnimated(false)
            self.dismissViewControllerAnimated(false, completion: { () -> Void in
            })
            ChoozeUtils.sharedInstance.shouldGoToMenu = false
        }
        
        didFinishLoadingData = false
        
        
        if self.nameLabel != nil {
            self.nameLabel.alpha = 0.0

        }
        self.leftLabel2.alpha = 0.0
        self.rightLabel2.alpha = 0.0
        self.leftLabel1.alpha  = 0.0
        self.rightLabel1.alpha = 0.0
        
        self.currentBlock = 1;
        
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillResignActiveNotification", name: UIApplicationWillResignActiveNotification, object: nil)
        
        EBTestData.sharedInstance.resetData()
        EBTestData.sharedInstance.initData(self.desiredNams, undesiredNames: self.undesiredNames, delegate: self)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation) {
            self.view.bringSubviewToFront(rotateScreenImage)
            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "rotationTimerFired", userInfo: nil, repeats: true)
        } else {
            self.view.sendSubviewToBack(rotateScreenImage)
            rotationTimerFired()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func applicationWillResignActiveNotification() {
        menuButtonPressed(self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show Results2" {
            var viewController = segue.destinationViewController as ResultsViewController
            viewController.prevViewController = self.prevViewController!
        }
    }
    
    
    func rotationTimerFired() {
        if !UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation) {
            self.view.sendSubviewToBack(rotateScreenImage)
            if timer != nil {
                timer!.invalidate()
            }
            waitingIndicator = EBWaitingIndicator(frame: self.view.frame)
            self.view.addSubview(waitingIndicator!)
            self.view.bringSubviewToFront(waitingIndicator!)
            
            
            var ebins = EBInstructions(frame: self.view.frame, delegate: self)
            self.view.addSubview(ebins)
            self.view.bringSubviewToFront(ebins)
        }
    }
    
    
    func startTest() {
        
        //set the layout
        self.leftLabel1.text = "Good Words"
        self.leftLabel2.text = "Desired Names"
        self.rightLabel1.text = "Bad Words"
        self.rightLabel2.text = "Undesired Names"
        
        self.selectCategoryExplenationLabel.alpha = 1.0
        UIView.animateWithDuration(5.0, animations: { () -> Void in
            self.selectCategoryExplenationLabel.alpha = 0.0
        })
        
        setLabelsAlpha(currentBlock)
        EBTestData.sharedInstance.getNext()
        
        
    }
    
    //IBActions
    
    @IBAction func menuButtonPressed(sender: AnyObject) {
        var elapsedTime:CFTimeInterval = 0.0
        if self.startTime != nil {
            elapsedTime = CACurrentMediaTime() - self.startTime!;
        }
        totalTimeSoFar = elapsedTime
        var menuView = EBTestMenuView(delegate: self, frame: self.view.frame)
        menuView.center = CGPointMake(self.view.center.x, self.view.center.y + 20)
        self.view.addSubview(menuView)
        self.view.bringSubviewToFront(menuView)
    }
    
    @IBAction func leftOrRightButtonPressed(sender: AnyObject) {
        
        self.leftPartButton.userInteractionEnabled = false
        self.rightPartButton.userInteractionEnabled = false
        
        var elapsedTime:CFTimeInterval = 0.0
        if self.startTime != nil {
            elapsedTime = CACurrentMediaTime() - self.startTime!;
            elapsedTime += totalTimeSoFar
        }
        if sender as NSObject == leftPartButton {
            EBTestData.sharedInstance.checkCurrent([self.leftLabel1.text!, self.leftLabel2.text!], responseTime: elapsedTime)
        }
        else if sender as NSObject == rightPartButton {
            EBTestData.sharedInstance.checkCurrent([self.rightLabel1.text!, self.rightLabel2.text!], responseTime: elapsedTime)
        }
    }
    
    private func switchLabels() {
        var tempText = self.leftLabel2.text
        self.leftLabel2.text = self.rightLabel2.text
        self.rightLabel2.text = tempText
    }
    
    private func setLabelsAlpha(blockNumber: Int) {
        if blockNumber == 1  || blockNumber == 5{
            self.leftLabel2.alpha = 1.0
            self.rightLabel2.alpha = 1.0
            self.leftLabel1.alpha  = 0.0
            self.rightLabel1.alpha = 0.0
        }
        else if blockNumber == 2  {
            self.leftLabel1.alpha = 1.0
            self.rightLabel1.alpha = 1.0
            self.leftLabel2.alpha = 0.0
            self.rightLabel2.alpha = 0.0
        }
            
            
        else {
            self.leftLabel1.alpha = 1.0
            self.rightLabel1.alpha = 1.0
            self.leftLabel2.alpha = 1.0
            self.rightLabel2.alpha = 1.0
        }
    }
    
    // MARK: - EBTestDataDelegate
    
    func finishedInitData() {
        waitingIndicator?.removeFromSuperview()
        didFinishLoadingData = true
    }
    
    func failedInitData() {
        var alertView = UIAlertView(title: "Error", message: "Fatal error in loading test", delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    func nextWord(word: String) {
        self.startTime = CACurrentMediaTime()
        self.nameLabel.text = word
        self.nameLabel.alpha = 1.0
        self.leftPartButton.userInteractionEnabled = true
        self.rightPartButton.userInteractionEnabled = true
    }
    
    func nextBlock(firstWord: String, blockType: Int) {
        currentBlock++
        println(currentBlock)
        self.setLabelsAlpha(currentBlock)
        if currentBlock == 5 {
            switchLabels()
        }
        self.firstWord = firstWord
        showBlock(currentBlock)
        
    }
    
    func showBlock(blockNumber: Int) {
        if blockNumber == 2 {
            var block = Block2View(frame: self.view.frame, delegate: self)
            self.view.addSubview(block)
            self.view.bringSubviewToFront(block)
        }
        else if blockNumber == 3 {
            var block = Block3View(frame: self.view.frame, delegate: self)
            self.view.addSubview(block)
            self.view.bringSubviewToFront(block)
        }
        else if blockNumber == 4 || blockNumber == 7 {
            var block = BlockSameView(frame: self.view.frame, delegate: self)
            self.view.addSubview(block)
            self.view.bringSubviewToFront(block)
        }
        else if blockNumber == 5 {
            var block = Block5View(frame: self.view.frame, delegate: self)
            self.view.addSubview(block)
            self.view.bringSubviewToFront(block)
        }
        else if blockNumber == 6 {
            var block = Block6View(frame: self.view.frame, delegate: self)
            self.view.addSubview(block)
            self.view.bringSubviewToFront(block)
        }
    }
    
    func testFinished() {
        var isCorrelate = (self.leftLabel1.text == "Desired Names" && self.leftLabel2.text == "Good Words") || (self.rightLabel1.text == "Desired Names" && self.rightLabel1.text == "Good Words") ? true : false
        EBTestData.sharedInstance.calculateResults(isCorrelate)
        
        waitingIndicator = EBWaitingIndicator(frame: self.view.frame)
        waitingIndicator!.showWaitingLabel()
        self.view.addSubview(waitingIndicator!)
        self.view.bringSubviewToFront(waitingIndicator!)
        
        delay(2.0, { () -> () in
            self.waitingIndicator?.removeFromSuperview()
            self.performSegueWithIdentifier("Show Results", sender: self)
        })
    }
    
    func wordCorrect() {
        self.nameLabel.alpha = 0.0
        delay(0.5, { () -> () in
            EBTestData.sharedInstance.getNext()
        })
        
    }
    
    func wordIncorrect() {
        
        self.rightPartButton.userInteractionEnabled = true
        self.leftPartButton.userInteractionEnabled = true
        
        if !didShowFirstMistake {
            didShowFirstMistake = true
            var firstTimeFailed = EBFirstMistakeView(frame: self.view.frame)
            self.view.addSubview(firstTimeFailed)
            self.view.bringSubviewToFront(firstTimeFailed)
        }
        
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.errorLabel.alpha = 1.0
            
            }) { (completed) -> Void in
                delay(3, { () -> () in
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        self.errorLabel.alpha = 0.0
                    })
                    
                })
        }
    }
    
    func checkIfCanStartTest() {
        if didFinishLoadingData {
            startTest()
            startTestTimer?.invalidate()
        }
    }
    
    // MARK: - EBInstructionsDelegate
    func instructionsFinished() {
        if didFinishLoadingData {
            startTest()
        } else {
            startTestTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("checkIfCanStartTest"), userInfo: nil, repeats: true)
        }
    }
    
    
    // MARK: - EBTestMenuViewDelegate
    func resumeTestSelected() {
        var countdown = CountDownView(frame: self.view.frame) { () -> () in
            self.startTime = CACurrentMediaTime()
        }
        self.view.addSubview(countdown)
        self.view.bringSubviewToFront(countdown)
    }
    func restartTestSelected() {
        
        waitingIndicator = EBWaitingIndicator(frame: self.view.frame)
        self.view.addSubview(waitingIndicator!)
        self.view.bringSubviewToFront(waitingIndicator!)
        
        
        didFinishLoadingData = false
        
        self.nameLabel.alpha = 0.0
        self.leftLabel2.alpha = 0.0
        self.rightLabel2.alpha = 0.0
        self.leftLabel1.alpha  = 0.0
        self.rightLabel1.alpha = 0.0
        
        self.currentBlock = 1;
        
        EBTestData.sharedInstance.resetData()
        EBTestData.sharedInstance.initData(self.desiredNams, undesiredNames: self.undesiredNames, delegate: self)
        
        
        startTestTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("checkIfCanStartTest"), userInfo: nil, repeats: true)
        
    }
    func returnToMenuSelected() {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
        })
    }
    
    // MARK: - EBBlockDelegate
    func blockAccepted() {
        if let tempWord = firstWord {
            nextWord(tempWord)
        }
    }
    
    
    
}
