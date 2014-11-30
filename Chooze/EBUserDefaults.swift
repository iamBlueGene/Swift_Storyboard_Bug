//
//  EBUserDefaults.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 9/23/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

private let _myUserDefaults = EBUserDefaults()

class EBUserDefaults: NSObject {
    class var sharedInstance : EBUserDefaults {
    return _myUserDefaults
    }
    
    func didRunApp() -> Bool {
        let didRun = NSUserDefaults.standardUserDefaults().boolForKey("didRun")
        if didRun {
            let boolToSet = true;
            NSUserDefaults.standardUserDefaults().setBool(boolToSet, forKey: "didRun")
            NSUserDefaults.standardUserDefaults().setInteger(2, forKey: "testsLeft")
            NSUserDefaults.standardUserDefaults().synchronize()
            
        }
        return didRun
    }
    
    func didShowChooseNamesInsturctions() -> Bool {
        var didShow = NSUserDefaults.standardUserDefaults().boolForKey("didShowChooseNamesInsturctions")
        if didShow {
            return true
        } else {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "didShowChooseNamesInsturctions")
            NSUserDefaults.standardUserDefaults().synchronize()
            return false
        }
    }
    
    func didTakeTest() -> Bool {
        var didTakeTest = NSUserDefaults.standardUserDefaults().boolForKey("didTakeTest")
        if didTakeTest {
            return true
        } else {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "didTakeTest")
            NSUserDefaults.standardUserDefaults().synchronize()
            return false
        }
    }
        
    
}
