//
//  EBTestNamesDataHandler.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 10/1/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

private var _myDataHandeling = EBTestNamesDataHandler()


class EBTestNamesDataHandler: NSObject {
    
    private var unavilableNames = Array<String>()
    private var currentNames = Array<String>()
    
    class var shardInstance : EBTestNamesDataHandler {
    return _myDataHandeling
    }
    
    func setUnavilableNames(names :Array<String>) {
        self.unavilableNames = names
    }
    
    func setCurrentNames(names: Array<String>) {
        self.currentNames = names
    }
    
    func getCurrentNames() -> Array<String> {
        return currentNames
    }
    
    func getUnavilableNames() -> Array<String> {
        return unavilableNames
    }
    
    func canAddName(name :String) -> Bool {
        if name.isEmpty {
            let alertView = UIAlertView(title: "Error", message: "Can't add an empty name", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
            return false
            
        }
        else if contains(currentNames, name) {
            let alertView = UIAlertView(title: "Error", message: "You can't add the same name twice", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
            return false
        }
        else if contains(unavilableNames, name) {
            let alertView = UIAlertView(title: "Error", message: "You cant add the same names in desired and undesired names", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
            return false
        }
            
        else {
            return true
        }
        
    }
    
    func checkIfCanAddAnotherName() -> Bool {
        if (self.unavilableNames.count != 0) && (self.unavilableNames.count <= self.currentNames.count) {
            let alertView = UIAlertView(title: "Error", message: "You can't add more undesired names than the amount of desired names", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
            return false
        }
        else if (self.currentNames.count > 3) {
            let alertView = UIAlertView(title: "Error", message: "You can't add more than four names", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
            return false
        }
        return true
    }
    
    func canStartTest() -> Bool {
        if unavilableNames.count < 2 || currentNames.count != unavilableNames.count {
            let alertView = UIAlertView(title: "Error", message: "Please add the same amount of undesired names as desired names", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
            return false
        }
        return true
    }
    
    func canGoToStepTwo() -> Bool {
        if currentNames.count >= 2 {
            return true
        }
        else {
            let alertView = UIAlertView(title: "Error", message: "Please add at least two names", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
        }
        return false
    }

}
