//
//  EBBlockWord.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 10/1/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

class EBBlockWord: NSObject {
    
    private var word:String
    private var isCorrect = true
    private var responseTime:Double = 0
    var wordType:String

    
    init(word :String, wordType: String) {
        self.word = word
        self.wordType = wordType
        super.init()
    }
    
    func setIsCorrect(isCorrect: Bool) {
        self.isCorrect = isCorrect
    }
    
    func getIsCorrect() -> Bool {
        return isCorrect
    }
    
    func setResponseTime(rpt :Double) {
        self.responseTime = rpt
    }
    
    func getResponseTime() -> Double {
        return responseTime
    }
    
    func getWord() -> String {
        return word
    }
    
    func checkIfCorrect(types :Array<String>) -> Bool {
        if contains(types, wordType) {
            self.isCorrect = true
            return true
        }
        else {
           self.isCorrect = false
            return false
        }
    }
   
}
