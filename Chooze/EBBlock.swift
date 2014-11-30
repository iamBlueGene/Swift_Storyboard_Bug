//
//  EBBlock.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 10/1/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

class EBBlock: NSObject {
    
    var blockWords: Array<EBBlockWord>
    private var blockType:Int
    private var wordIndex = 0
    
    init(wordsToUse: Array<EBBlockWord>, blockType :Int) {
        self.blockWords = wordsToUse
        self.blockType = blockType
        super.init()
    }
    
    func getNextWord() -> EBBlockWord? {
        if wordIndex < blockWords.count {
            let tempI = wordIndex
            wordIndex++
            return blockWords[tempI]
        }
        return nil
    }
    
    func getBlockType() -> Int {
        return blockType
    }
    
    func averageResponseTimes() -> EBBlock {
        var block:EBBlock
        var wordsForBlock = Array<EBBlockWord>()
        var newArray = Array<EBBlockWord>(blockWords)
        while newArray.count != 0 {
            var firstWord = newArray.first
            if firstWord != nil {
                var filterdArray  = newArray.filter{$0.getWord() == firstWord?.getWord()}
                var avgTime:Double = 0;
                for word in filterdArray {
                    avgTime += word.getResponseTime()
                }
                avgTime = avgTime / Double(filterdArray.count)
                var tempWord = EBBlockWord(word: firstWord!.getWord(), wordType: firstWord!.wordType)
                tempWord.setResponseTime(avgTime)
                wordsForBlock.append(tempWord)
                for word in filterdArray {
                    let index = find(newArray, word)
                    if index != nil {
                        newArray.removeAtIndex(index!)
                    }
                }
            }
        }
        block = EBBlock(wordsToUse: wordsForBlock, blockType: EBBlockType.AverageWordTime)
        return block
    }
    
    func standardDiviation() -> EBBlock {
        var block:EBBlock
        var wordsForBlock = Array<EBBlockWord>()
        var newArray = Array<EBBlockWord>(blockWords)
        while newArray.count != 0 {
            var firstWord = newArray.first
            if firstWord != nil {
                var filterdArray = newArray.filter{$0.getWord() == firstWord?.getWord()}
                let standardDivationOfName = ChoozeUtils.standardDeviationOf(responseTimes(filterdArray))
                let tempWord = EBBlockWord(word: firstWord!.getWord(), wordType: firstWord!.wordType)
                tempWord.setResponseTime(standardDivationOfName)
                wordsForBlock.append(tempWord)
                for word in filterdArray {
                    let index = find(newArray, word)
                    if index != nil {
                        newArray.removeAtIndex(index!)
                    }
                }
            }
        }
        block = EBBlock(wordsToUse: wordsForBlock, blockType: EBBlockType.StandardDiviation)
        return block
        
    }
    
    func getBlockWord(word: String) -> EBBlockWord? {
        var filterdArray = blockWords.filter{$0.getWord() == word}
        if let tempWord = filterdArray.first {
            return tempWord
        }
        return nil
    }
    
    private func responseTimes(words :Array<EBBlockWord>) -> Array<Double> {
        var responseTimes = Array<Double>()
        for word in words {
            responseTimes.append(word.getResponseTime())
        }
        return responseTimes
    }
    
    private func calculateAvergaeForWords(words :Array<EBBlockWord>) -> Double {
        var totalTime:Double = 0
        for word in words {
            totalTime += word.getResponseTime()
        }
        
        return totalTime/Double(words.count)
    }
    
    
    
}
