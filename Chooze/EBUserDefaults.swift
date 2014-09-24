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
    
    
}
