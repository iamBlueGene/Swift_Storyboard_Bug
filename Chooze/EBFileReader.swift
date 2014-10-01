//
//  EBFileReader.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 9/28/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

class EBFileReader: NSObject {
    
    class func getIntroInfo() -> Array<String> {
        var contentsArray = Array<String>()
        
        var language = ChoozeUtils.getLanguage()
        var fileName = language + "IntroPagesInfo"
        if let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: "cif") {
            if let fileContents = String.stringWithContentsOfFile(filePath, encoding: NSUTF8StringEncoding, error: nil) {
                contentsArray = fileContents.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
                
                for var i = 0; i < contentsArray.count; i++ {
                    contentsArray[i] = contentsArray[i].stringByReplacingOccurrencesOfString("\\n", withString: "\n", options: nil, range: nil)
                }
                
                return contentsArray
                
            }
        }
        return contentsArray
    }
    
    class func getQuestionsInfo() -> Array<String> {
        var contentsArray = Array<String>()
        var language = ChoozeUtils.getLanguage()
        var fileName = language + "QuestionsInfo"
        if let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: "cif") {
            if let fileContents = String.stringWithContentsOfFile(filePath, encoding: NSUTF8StringEncoding, error: nil) {
                contentsArray = fileContents.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
                return contentsArray
            }
        }
        return contentsArray
    }
    
    class func getAnswersInfo() -> Array<String> {
        var contentsArray = Array<String>()
        var language = ChoozeUtils.getLanguage()
        var fileName = language + "AnswersInfo"
        if let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: "cif") {
            if let fileContents = String.stringWithContentsOfFile(filePath, encoding: NSUTF8StringEncoding, error: nil) {
                contentsArray = fileContents.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
                return contentsArray
            }
        }
        return contentsArray
    }

    
}
