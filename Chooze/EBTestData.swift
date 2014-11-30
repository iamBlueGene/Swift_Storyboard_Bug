//
//  EBTestData.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 10/1/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

private var _myTestData = EBTestData()

class EBTestData: NSObject, EBWordsInfoServiceDelegate {
    
    private var blocks = Array<EBBlock>()
    private var desiredNames = Array<String>()
    private var undesiredNames = Array<String>()
    private var calculatedNames: Array<EBBlockWord>?
    
    private var delegate:EBTestDataDelegate?
    
    
    private var currentWord:EBBlockWord?
    
    private var blockIndex:Int = 0
   
    class var sharedInstance : EBTestData {
        return _myTestData
    }
    
    func initData(desiredNames: Array<String>, undesiredNames: Array<String>, delegate :EBTestDataDelegate){
        self.desiredNames = desiredNames
        self.undesiredNames = undesiredNames
        self.delegate = delegate
        EBWordsInfoService.sharedInstance.initData(self,desiredNames: desiredNames, undesiredNames: undesiredNames)
    }
    
    func resetData() {
        self.blocks = Array<EBBlock>()
        self.calculatedNames = nil
        currentWord = nil
        blockIndex = 0
        
    }
    
    func getNext() {
        if blockIndex < blocks.count {
            var word = blocks[blockIndex].getNextWord()
            if word != nil {
                currentWord = word
                self.delegate?.nextWord(word!.getWord())
            } else {
                blockIndex++
                if blockIndex < blocks.count {
                    var currentBlock = self.blocks[blockIndex]
                    var tempWord = currentBlock.getNextWord()
                    if tempWord != nil {
                        currentWord = tempWord
                        self.delegate?.nextBlock(tempWord!.getWord(), blockType: currentBlock.getBlockType())
                    }
                }
                else {
                    self.delegate?.testFinished()
                }
            }
        }
        else {
            self.delegate?.testFinished()
        }
    }
    
    func checkCurrent(types: Array<String>, responseTime: Double) {
        if currentWord != nil {
            currentWord?.setResponseTime(responseTime)
            let isCorrect:Bool  = currentWord!.checkIfCorrect(types)
            if isCorrect {
                self.delegate?.wordCorrect()
            } else {
                self.delegate?.wordIncorrect()
            }
        }
    }
    
    func calculateResults(isTypesMatching: Bool) {
        calculatedNames = EBTestDataCalculator.sharedInstance.calculateResults(blocks, isTypesMatching: isTypesMatching)
    }
    
    func getCalculatedNames() -> Array<EBBlockWord>? {
        return calculatedNames
    } 
    
    
    
    // MARK: - EBWordsInfoServiceDelegate
    
    func wordsInitComplete() {
        
        
    }
    func wordsInitComplete(goodWords: Array<String>, badWords: Array<String>, whichBlockToStartWith: Int) {
        self.blocks  = EBBlockDataService.sharedInstance.createBlocks(goodWords, badWords: badWords, desiredNames: self.desiredNames, undesiredNames: self.undesiredNames, whichBlockToStartWith: whichBlockToStartWith)
        self.delegate?.finishedInitData()
    }
    
    func wordsInitFailed() {
        self.delegate?.failedInitData()
    }
}

protocol EBTestDataDelegate {
    func finishedInitData()
    func failedInitData()
    func nextWord(word :String)
    func nextBlock(firstWord: String, blockType: Int)
    func testFinished()
    func wordCorrect()
    func wordIncorrect()
}
