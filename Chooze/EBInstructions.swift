//
//  EBInstructions.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 10/29/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

class EBInstructions: UIView, EBInstructionDelegate {
    
    private var delegate: EBInstructionsDelegate
    private var views = Array<UIView>()

    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(frame: CGRect, delegate : EBInstructionsDelegate) {
        self.delegate = delegate
        super.init(frame: frame)
        var page1 = EBTestInstruction1(frame: self.frame, delegate: self)
        var page2 = EBTestInstruction2(frame: self.frame, delegate: self)
        var page3 = EBTestInstruction3(frame: self.frame, delegate: self)
        var page4 = EBTestInstruction4(frame: self.frame, delegate: self)


        views.append(page1)
        views.append(page2)
        views.append(page3)
        views.append(page4)
        
        self.addSubview(views.first!)

    }
    
    //EBInstructionDelegate
    func nextPage() {
        views.removeAtIndex(0)
        if let tempView = views.first! as? EBTestInstruction2 {
            tempView.animateHand()
        }
        if let tempView = views.first! as? EBTestInstruction3 {
            tempView.animateHand()
        }
        
        self.addSubview(views.first!)
    }
    func lastPage() {
        self.delegate.instructionsFinished()
        self.removeFromSuperview()
    }

}

protocol EBInstructionsDelegate {
    func instructionsFinished()
}
