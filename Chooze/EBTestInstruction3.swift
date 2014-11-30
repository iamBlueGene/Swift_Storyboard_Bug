//
//  EBTestInstruction3.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 10/29/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

class EBTestInstruction3: UIView {

    private var delegate: EBInstructionDelegate
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var handImage: UIImageView!
    @IBOutlet weak var handYPosConstrain: NSLayoutConstraint!
    @IBOutlet weak var handXPosConstrain: NSLayoutConstraint!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, delegate :EBInstructionDelegate) {
        self.delegate = delegate
        super.init(frame: frame)
        ChoozeUtils.loadViewsFromBundle(self.classForCoder, classOwner: self)
        self.addSubview(self.contentView)
        self.backgroundColor = UIColor.clearColor()
        self.contentView.frame = self.frame
        self.clipsToBounds = true
        self.contentView.clipsToBounds = true
        setButtonDesign(okButton)
        setButtonDesign(skipButton)
    }
    
    
    
    func setButtonDesign(button :UIButton) {
        button.layer.cornerRadius = 22
        button.layer.borderColor = UIColor.whiteColor().CGColor
        button.layer.borderWidth = 1
    }
    
    
    
    @IBAction func okButtonPressed(sender: AnyObject) {
        self.delegate.nextPage()
        self.removeFromSuperview()
    }
    
    func animateHand() {
        delay(0.5, { () -> () in
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.handImage.alpha = 1.0
                self.handXPosConstrain.constant = 0
                self.handYPosConstrain.constant = 8
                self.handImage.layoutIfNeeded()
            })
        })

    }
    
    @IBAction func skipButtonPressed(sender: AnyObject) {
        self.delegate.lastPage()
        self.removeFromSuperview()
    }
    
    
}