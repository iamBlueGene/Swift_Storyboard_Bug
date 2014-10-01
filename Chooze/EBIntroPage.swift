//
//  EBIntroPage.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 9/26/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

class EBIntroPage: UIView {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoImage: UIImageView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet var contentView: UIView!
    
    private var delegate:EBIntroPageProtocol
    
    
    init(delegate :EBIntroPageProtocol, frame :CGRect) {
        self.delegate = delegate
        super.init(frame: frame)
    }
    
    convenience init(imageName :String, infoText: String,delegate :EBIntroPageProtocol, frame :CGRect) {
        self.init(delegate: delegate, frame: frame)
        self.loadViewsFromBundle()
        self.infoImage.image = UIImage(named: imageName)
        self.infoLabel.text = infoText
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func loadViewsFromBundle() {
        var classString = NSStringFromClass(self.classForCoder)
        let classArray:Array<String> = classString.componentsSeparatedByString(".")
        let className = classArray.last!;
        NSBundle.mainBundle().loadNibNamed(className, owner: self, options: nil)
        self.contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        self.addSubview(self.contentView)

    }
    
    func turnOnDoneButton() {
        self.doneButton.hidden = false;
    }
    
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        self.delegate.introPageDone()
    }

}

protocol EBIntroPageProtocol {
    func introPageDone()
}
