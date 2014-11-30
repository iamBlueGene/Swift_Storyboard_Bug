//
//  EBWordsInfoService.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 10/1/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

private var _myWordsInfoService = EBWordsInfoService()

class EBWordsInfoService: NSObject {
    
    private var didFinishInitInTime = false
    private var k_timerInterval:Double = 10
    
    private var delegate:EBWordsInfoServiceDelegate?
    
    private var goodWords = Array<String>()
    private var badWords = Array<String>()
    private var whichTypeOfBlockToUseFirst:Int = 0
    
    class var sharedInstance :EBWordsInfoService {
        return _myWordsInfoService
    }
    
    func initData(delegate: EBWordsInfoServiceDelegate, desiredNames: Array<String>, undesiredNames: Array<String>) {
        self.delegate = delegate
        initDataFromNet()
        NSTimer.scheduledTimerWithTimeInterval(k_timerInterval, target: self, selector: "timerFired:", userInfo: nil, repeats: false)
    }
    
    // TODO:
    private func initDataFromNet() {
        EBParseService.getGoodWords({ (words) -> () in
            self.goodWords = words
            EBParseService.getBadWords({ (words) -> () in
                self.badWords = words
                EBParseService.getWhichTypeOfBlocksToStartWith({ (type) -> () in
                    let a = type
                    self.delegate?.wordsInitComplete(self.goodWords, badWords: self.badWords, whichBlockToStartWith: a)
                })
            })
        })
    }
    
    private func initDataFromLocal() {
        self.goodWords = EBFileReader.getWords("GoodWords")
        self.badWords = EBFileReader.getWords("BadWords")
        self.delegate?.wordsInitComplete(self.goodWords, badWords: self.badWords, whichBlockToStartWith: 0)
    }
   
    func timerFired(timer: NSTimer) {
        if !didFinishInitInTime {
            // stop net init
            initDataFromLocal()
        }
    }
}

protocol EBWordsInfoServiceDelegate {
    func wordsInitComplete(goodWords: Array<String>, badWords: Array<String>, whichBlockToStartWith: Int)
    func wordsInitFailed()
}
