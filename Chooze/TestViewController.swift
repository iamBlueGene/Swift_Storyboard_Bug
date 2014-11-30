//
//  TestViewController.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 10/1/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

 class TestViewController: UIViewController {
    
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
       
    }
    
    
    func rotationTimerFired() {
        if !UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation) {
            self.view.sendSubviewToBack(rotateScreenImage)
            if timer != nil {
                timer!.invalidate()
            }
           
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
        
        
    }
    
    //IBActions
    
    @IBAction func menuButtonPressed(sender: AnyObject) {

    }
    
    @IBAction func leftOrRightButtonPressed(sender: AnyObject) {
        
        }
    
    private func switchLabels() {
        var tempText = self.leftLabel2.text
        self.leftLabel2.text = self.rightLabel2.text
        self.rightLabel2.text = tempText
    }
    
    private func setLabelsAlpha(blockNumber: Int) {
       
    }
    
    // MARK: - EBTestDataDelegate
    
    func finishedInitData() {
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
       
    }
    
    func testFinished() {
           }
    
    func wordCorrect() {
       
        
    }
    
    func wordIncorrect() {
       
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
      
    }
    func restartTestSelected() {
        
        
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
