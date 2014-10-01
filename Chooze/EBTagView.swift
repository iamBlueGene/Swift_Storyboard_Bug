//
//  EBTagView.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 9/28/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

class EBTagView: UIView, UITextFieldDelegate {
    
    private var tagID:Int = 0
    private var delegate:EBTagViewDelegate?
    var backgroundEditButton:UIButton
    private var nameTextField:UITextField
    private var textLength:Int = 0
    
    private var k_OriginalWidth:CGFloat = 53
    private var k_OriginalHeight:CGFloat = 43
    private var k_OffsetWidth:CGFloat = 15
    private var k_OffsetHeight:CGFloat = 5
    private var k_TextOffset:CGFloat = 9
    private var k_ViewFrameOffset:CGFloat = 7
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override init() {
        self.backgroundEditButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        self.nameTextField = UITextField()
        super.init(frame: CGRectMake(0, 0, k_OriginalWidth, k_OriginalHeight))
    }
    

    convenience init(tagID :Int, delegate: EBTagViewDelegate) {
        
        self.init()
        
        self.tagID = tagID
        self.delegate = delegate
        
        self.layer.borderWidth = 1
        self.layer.borderColor = ChoozeUtils.rgbColor(91, greenValue: 177, blueValue: 243).CGColor
        self.layer.cornerRadius = 22
        self.backgroundColor = UIColor.whiteColor()
        
        
        self.backgroundEditButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        self.backgroundEditButton.backgroundColor = UIColor.clearColor()
        self.backgroundEditButton.enabled = false
        self.backgroundEditButton.addTarget(self, action: "deleteSelfButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let textWidth = self.frame.size.width - (k_OffsetWidth * 2);
        let textHeight = self.frame.size.height - (k_OffsetHeight * 2);
        
        self.nameTextField.frame = CGRectMake(k_OffsetWidth, k_OffsetHeight, textWidth, textHeight)
        self.nameTextField.textColor = ChoozeUtils.rgbColor(37, greenValue: 163, blueValue: 223)
        self.nameTextField.font = UIFont.systemFontOfSize(15)
        self.nameTextField.delegate = self
        self.nameTextField.returnKeyType = UIReturnKeyType.Done
        self.nameTextField.enablesReturnKeyAutomatically = true
        
        self.addSubview(self.nameTextField)
        self.insertSubview(self.backgroundEditButton, belowSubview: self.nameTextField)
        
        self.clipsToBounds = true
        
    }

    private func makeNameView() {
        var backgroundImageView = UIImageView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        backgroundImageView.image = UIImage(named: "introPageBackgroundImage")
        backgroundImageView.contentMode = UIViewContentMode.ScaleToFill
        self.insertSubview(backgroundImageView, belowSubview: self.nameTextField)
        
        self.layer.borderWidth = 0
        
        self.nameTextField.textColor = UIColor.whiteColor()
        let width = self.frame.size.width / 2;
        let height = self.frame.size.height / 2;
        
        self.nameTextField.center = CGPointMake(width, height)
        self.nameTextField.textAlignment = NSTextAlignment.Center
        self.nameTextField.enabled = false
        
        
    }
    
    func getName() -> String {
        return self.nameTextField.text
    }
    
    func hideKeyboard() {
        self.nameTextField.resignFirstResponder()
    }
    
    func showKeyboard() {
        self.nameTextField.becomeFirstResponder()
    }
    
    func removeKeyboard() {
        self.nameTextField.resignFirstResponder()
        makeNameView()
        self.delegate?.finishedWriting()
    }
    
    func deleteSelfButtonPressed(sender: UIButton!) {
        self.delegate?.deleteTag(self)
    }
    
    // MARK: - TextFieldDelegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let allText = self.nameTextField.text + string
        let myString: NSString = allText as NSString
        let stringSize = myString.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(15)])
        let width = stringSize.width + k_TextOffset
        
        self.nameTextField.frame = CGRectMake(self.nameTextField.frame.origin.x, self.nameTextField.frame.origin.y, width, self.nameTextField.frame.size.height)
        
        var sizeToMake = (self.nameTextField.frame.size.width + (2 * k_OffsetWidth)) - k_ViewFrameOffset
        if sizeToMake <= k_OriginalWidth {
            sizeToMake = k_OriginalWidth
        }
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, sizeToMake, self.frame.size.height)
        self.backgroundEditButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        self.delegate?.nameChanged()
        
        return true

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.delegate?.tryToAddName(self.nameTextField.text, nameView: self)
        return false
    }

}


protocol EBTagViewDelegate {
    
    func tryToAddName(name: String, nameView:EBTagView) -> Bool
    func finishedWriting()
    func deleteTag(tag: EBTagView)
    func nameChanged()
}