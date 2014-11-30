//
//  EBWaitingIndicator.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 11/20/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

class EBWaitingIndicator: UIView {
    
    private var waitingIn:UIActivityIndicatorView

    override init(frame: CGRect) {

        waitingIn = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        super.init(frame: frame)

        self.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        waitingIn.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        waitingIn.center = self.center
        waitingIn.startAnimating()
        self.addSubview(waitingIn)
        
    }
    
    func showWaitingLabel() {
        var label = UILabel(frame: CGRectMake(0, 0, 200, 50))
        label.text = "Calculating Results"
        label.textAlignment = NSTextAlignment.Center
        label.center = CGPointMake(waitingIn.center.x, waitingIn.frame.origin.y + waitingIn.frame.height + 30)
        label.textColor = UIColor.whiteColor()
        
        self.addSubview(label)
    }

    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
