//
//  CountDownView.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 10/30/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

class CountDownView: UIView {

    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    private var comp:() -> () = {}
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect,  completed: (() ->())) {
        super.init(frame: frame)
        ChoozeUtils.loadViewsFromBundle(self.classForCoder, classOwner: self)
        self.addSubview(self.contentView)
        self.backgroundColor = UIColor.clearColor()
        self.contentView.frame = self.frame
        self.clipsToBounds = true
        self.contentView.clipsToBounds = true
        startCountDown()
        self.comp = completed
    }
    
    func startCountDown() {
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.numberLabel.transform = CGAffineTransformMakeScale(0.6, 0.6)
            self.numberLabel.alpha = 0.0
        }) { (completed) -> Void in
            self.numberLabel.transform = CGAffineTransformMakeScale(1.0, 1.0)
            self.numberLabel.alpha = 1.0
            self.numberLabel.text = "2"
            
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.numberLabel.transform = CGAffineTransformMakeScale(0.6, 0.6)
                self.numberLabel.alpha = 0.0
            }, completion: { (completed) -> Void in
                self.numberLabel.transform = CGAffineTransformMakeScale(1.0, 1.0)
                self.numberLabel.alpha = 1.0
                self.numberLabel.text = "1"
                
                UIView.animateWithDuration(1.0, animations: { () -> Void in
                    self.numberLabel.transform = CGAffineTransformMakeScale(0.6, 0.6)
                    self.numberLabel.alpha = 0.0
                }, completion: { (completed) -> Void in
                    self.comp()
                    self.removeFromSuperview()
                })
            })

        }
    }
    
    
    
}
