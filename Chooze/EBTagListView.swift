//
//  EBTagListView.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 9/28/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

class EBTagListView: UIView, EBTagViewDelegate {
    
    
    private let k_CircleSize = 43
    private let k_AddButtonSizeShiftingConstant:CGFloat = 67
    private let k_NewTagViewPlacementConstant:CGFloat = 6
    private let k_NewLinePlacenebtConstant:CGFloat = 49
    
    private var status = 0
    //private var outStatus = EBTagListStatus.Normal
    private var numberOfTags = 0
    private var nameViews = Array<EBTagView>()
    private var unavilableNames = Array<String>()
    private var nameTagView:EBTagView?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var addNameButton: UIButton!
    @IBOutlet weak var addNameButtonWidthConstrain: NSLayoutConstraint!
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        ChoozeUtils.loadViewsFromBundle(self.classForCoder, classOwner: self)
        self.contentView.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
        self.addSubview(self.contentView)
        
        self.addNameButton.layer.borderWidth = 1;
        self.addNameButton.layer.borderColor = ChoozeUtils.rgbColor(91, greenValue: 177, blueValue: 243).CGColor;
        self.addNameButton.layer.cornerRadius = 22;
        self.addNameButton.backgroundColor = UIColor.whiteColor()
        
        status = EBTagListStatus.Normal;
    }
    
    @IBAction func addNameButtonPressed(sender: AnyObject) {
        if (status != EBTagListStatus.AddingName) {
            if (self.nameViews.count > 3) {
                let alertView = UIAlertView(title: "Error", message: "You can't add more than four names", delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
                return;
            }
            else if (self.unavilableNames.count != 0 && (self.unavilableNames.count <= self.nameViews.count)) {
                let alertView = UIAlertView(title: "Error", message: "You can't add more undesired names than the amount of desired names", delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
                return;
            }
            status = EBTagListStatus.AddingName;

            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.addNameButton.setTitle("+", forState: UIControlState.Normal)
                self.addNameButtonWidthConstrain.constant = self.addNameButtonWidthConstrain.constant - self.k_AddButtonSizeShiftingConstant
                self.layoutIfNeeded()
            }, completion: { (finised) -> Void in
                self.nameTagView = EBTagView(tagID: self.numberOfTags, delegate: self)
                let whereToPlaceNewTagView = self.addNameButton.frame.origin.x +  self.addNameButton.frame.size.width + self.k_NewTagViewPlacementConstant;
                self.nameTagView?.frame = CGRectMake(whereToPlaceNewTagView , self.addNameButton.frame.origin.y, self.nameTagView!.frame.size.width, self.nameTagView!.frame.size.height)
                self.contentView.addSubview(self.nameTagView!)
                self.nameTagView?.showKeyboard()
                self.nameViews.insert(self.nameTagView!, atIndex: 0)
                EBTestNamesDataHandler.shardInstance.setCurrentNames(self.getNames())
            })
            
            
            
        }
        else if (status == EBTagListStatus.AddingName) {
            let canAdd = self.tryToAddName(self.nameTagView!.getName(), nameView: self.nameTagView!)
            if (canAdd) {
                var timer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "addNameButtonPressed:", userInfo: nil, repeats: false)

            }
        }

    }
    
    private func layoutNames() {
        var totalWidth:CGFloat = self.addNameButton.frame.origin.x + self.addNameButton.frame.size.width;
        var currentY = self.addNameButton.frame.origin.y;
        
        for nameTag in self.nameViews {
            if ((totalWidth + k_NewTagViewPlacementConstant + nameTag.frame.size.width) <= self.frame.size.width) {
                totalWidth += k_NewTagViewPlacementConstant + nameTag.frame.size.width;
                
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    nameTag.frame = CGRectMake((totalWidth - nameTag.frame.size.width), currentY, nameTag.frame.size.width, nameTag.frame.size.height);

                })
            } else {
                totalWidth = self.addNameButton.frame.origin.x;
                currentY += k_NewLinePlacenebtConstant;
                totalWidth +=  nameTag.frame.size.width;
                
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    nameTag.frame = CGRectMake((totalWidth - self.k_NewTagViewPlacementConstant - nameTag.frame.size.width), currentY, nameTag.frame.size.width, nameTag.frame.size.height);
                })
            }
        }

    }
    
    private func removeFirstResponder() {
        if status == EBTagListStatus.Editing {
            self.nameTagView?.removeKeyboard()
            var index = find(self.nameViews, self.nameTagView!)
            self.nameViews.removeAtIndex(index!)
            self.nameTagView?.removeFromSuperview()
            self.nameTagView = nil
            self.canceledWriting()
        }
    }
    
    func startWritingNames() {
        self.addNameButtonPressed(self)
        status = EBTagListStatus.AddingName
    }
    
    private func getNames() -> Array<String> {
        var names = Array<String>()
        for tagView in self.nameViews {
            names.append(tagView.getName())
        }
        return names
    }
    
    func setStatus(newStatus: Int) {
        if (newStatus == EBTagListStatus.Editing) {
            self.addNameButton.userInteractionEnabled = false;
            for tagView in self.nameViews {
                tagView.backgroundEditButton.enabled = true;
            }
        }
        else if (newStatus == EBTagListStatus.Normal) {
            self.addNameButton.userInteractionEnabled = true;
            for tagView in self.nameViews {
                tagView.backgroundEditButton.enabled = false;
            }
        }
    }
    
    func getNumberOfNames() -> Int {
        return self.nameViews.count
    }
    
    func canDeleteNames() -> Bool {
        if status == EBTagListStatus.Normal {
            return true
        }
        return false
    }
    
    
    // MARK: - EBTagViewDelegate 
    func finishedWriting() {
        status = EBTagListStatus.Normal
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.addNameButtonRegular()
            self.nameTagView!.frame = CGRectMake(self.nameTagView!.frame.origin.x + self.k_AddButtonSizeShiftingConstant, self.nameTagView!.frame.origin.y, self.nameTagView!.frame.size.width, self.nameTagView!.frame.size.height);
        }) { (finished) -> Void in
            EBTestNamesDataHandler.shardInstance.setCurrentNames(self.getNames())
            self.nameTagView = nil
            self.layoutNames()
        }
    }
    
    func canceledWriting() {
        status = EBTagListStatus.Normal
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.addNameButtonRegular()
            self.layoutIfNeeded()
        }) { (finished) -> Void in
            self.layoutNames()
        }
    }
    
    private func addNameButtonRegular() {
        self.addNameButton.setTitle("Add Name", forState: UIControlState.Normal)
        self.addNameButtonWidthConstrain.constant = self.addNameButtonWidthConstrain.constant + self.k_AddButtonSizeShiftingConstant;
    }

    func nameChanged() {
        self.layoutNames()
    }
    
    func deleteTag(tag: EBTagView) {
        var index = find(self.nameViews, tag)
        self.nameViews.removeAtIndex(index!)
        tag.removeFromSuperview()
        self.layoutNames()
        EBTestNamesDataHandler.shardInstance.setCurrentNames(getNames())
    }
    
    func tryToAddName(name: String, nameView: EBTagView) -> Bool {
        
        let canAddName = EBTestNamesDataHandler.shardInstance.canAddName(name)
        
            if canAddName {
            nameView.removeKeyboard()
            status = EBTagListStatus.Normal
            return true
        }
            else {
                return false
        }
    }
    

}
