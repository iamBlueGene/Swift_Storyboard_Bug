//
//  ChoozeUtils.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 9/26/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

class ChoozeUtils: NSObject {
   
    
    class func getLanguage() -> String {
        var language = NSLocale.preferredLanguages().first! as String
        return language
    }
    
    class func showError(error :NSError) {
        let errorDictionery:NSDictionary = error.userInfo!
        
        var anyError: AnyObject? = errorDictionery.objectForKey("error")
        if anyError != nil {
            let tempError = anyError as String
            var alertView = UIAlertView(title: "Error", message: tempError, delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
        }
        else {
            anyError = errorDictionery.objectForKey("NSLocalizedDescription")
            if anyError != nil {
                let tempError = anyError as String
                var alertView = UIAlertView(title: "Error", message: tempError, delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
            }
            
            else {
                var alertView = UIAlertView(title: "Error", message: "An unknown error accurred", delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
            }

        }
    }
    
    class func degreesToRadians(angle :Double) -> Double {
        return ((angle) / 180.0 * M_PI)
    }
    
    class func rgbColor(redValue: CGFloat, greenValue: CGFloat, blueValue: CGFloat) ->UIColor {
        return UIColor(red: (redValue/255.0), green: (greenValue/255.0), blue: (blueValue/255.0), alpha: 1.0)
    }
    
    class func calculateHeightForLabel(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        var label = UILabel(frame: CGRectMake(0, 0, width, 1000))
        label.numberOfLines = 0
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    
    class func loadViewsFromBundle(className: AnyClass, classOwner: AnyObject) {
        var classString = NSStringFromClass(className)
        let classArray:Array<String> = classString.componentsSeparatedByString(".")
        let className = classArray.last!;
        NSBundle.mainBundle().loadNibNamed(className, owner: classOwner, options: nil)
    }
}
