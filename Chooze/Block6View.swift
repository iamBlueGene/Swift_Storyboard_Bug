//
//  EBBlock6View.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 10/29/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

class Block6View: UIView {

    private var delegate: EBBlockDelegate
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var okButton: UIButton!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, delegate :EBBlockDelegate) {
        self.delegate = delegate
        super.init(frame: frame)
        ChoozeUtils.loadViewsFromBundle(self.classForCoder, classOwner: self)
        self.addSubview(self.contentView)
        self.backgroundColor = UIColor.clearColor()
        self.contentView.frame = self.frame
        self.clipsToBounds = true
        self.contentView.clipsToBounds = true
        setButtonDesign(okButton)
    }
    
    
    
    func setButtonDesign(button :UIButton) {
        button.layer.cornerRadius = 22
        button.layer.borderColor = UIColor.whiteColor().CGColor
        button.layer.borderWidth = 1
    }
    
    
    
    @IBAction func okButtonPressed(sender: AnyObject) {
        self.delegate.blockAccepted()
        self.removeFromSuperview()
    }
    
}