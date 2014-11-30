//
//  EBTestMenuView.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 10/28/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

class EBTestMenuView: UIView {
    
    //IBOutlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var returnToMenuButton: UIButton!
    @IBOutlet weak var darkerView: UIView!

    private var deleagte:EBTestMenuViewDeleagte

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(delegate :EBTestMenuViewDeleagte, frame: CGRect) {
        self.deleagte = delegate
        super.init(frame: frame)
        ChoozeUtils.loadViewsFromBundle(self.classForCoder, classOwner: self)
        self.contentView.frame  = frame
        self.backgroundColor = UIColor.clearColor()
        self.contentView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.85)
        self.addSubview(self.contentView)
        //self.frame = self.contentView.frame
        self.clipsToBounds = true
        self.contentView.clipsToBounds = true
        setDesign()
    }
    
    func setDesign() {
        self.darkerView.layer.shadowRadius = 10
        self.darkerView.layer.shadowColor = UIColor.blackColor().CGColor
        self.darkerView.layer.shadowOpacity = 0.5
        self.darkerView.layer.shadowOffset = CGSizeMake(0, 5)
        
        setButtonDesign(resumeButton)
        setButtonDesign(restartButton)
        setButtonDesign(returnToMenuButton)
        
    }
    
    func setButtonDesign(button :UIButton) {
        button.layer.cornerRadius = 22
        button.layer.borderColor = UIColor.whiteColor().CGColor
        button.layer.borderWidth = 1
    }
    
    private func removeSelf() {
        self.removeFromSuperview()
    }

    @IBAction func resumeButtonPressed(sender: AnyObject) {
        self.deleagte.resumeTestSelected()
        removeSelf()
    }
    @IBAction func restartButtonPressed(sender: AnyObject) {
        self.deleagte.restartTestSelected()
        removeSelf()
    }
    @IBAction func returnToMenuPressed(sender: AnyObject) {
        self.deleagte.returnToMenuSelected()
        removeSelf()
    }
    
    
    

}

protocol EBTestMenuViewDeleagte {
    func resumeTestSelected()
    func restartTestSelected()
    func returnToMenuSelected()
}
