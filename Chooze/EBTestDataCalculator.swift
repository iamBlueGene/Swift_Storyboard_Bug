//
//  EBTestDataCalculator.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 10/2/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

private var _myTestDataCalc = EBTestDataCalculator()

class EBTestDataCalculator: NSObject {
    
    class var sharedInstance : EBTestDataCalculator {
        return _myTestDataCalc
    }
    
    func  calculateResults(blocks :Array<EBBlock>, isTypesMatching: Bool) -> Array<EBBlockWord> {
        // step 1: take blocks 3,4,6,7
        var workingBlocks = [blocks[2], blocks[3], blocks[5],blocks[6]]
        
        //step 2: filter all responseTimesOver 5000ms
        for i in 0..<workingBlocks.count {
            var words = workingBlocks[i].blockWords
            workingBlocks[i].blockWords = words.filter{word in word.getResponseTime() <= 5000}
        }
        
        //step 4: avergage words response times
        var averageTimesBlocks = Array<EBBlock>()
        for i in 0..<workingBlocks.count {
            averageTimesBlocks.append(workingBlocks[i].averageResponseTimes())
        }
        
        //step 5: calculate combined standard diviation for each word in blocks (3 + 6) and (4 + 7)
        
        //step 5.1: create new arrays with blocks combined
        var blocksCombinedForStandardDiviation = Array<EBBlock>()
        var tempArray1 = workingBlocks[0].blockWords + workingBlocks[2].blockWords
        var tempArray2 = workingBlocks[1].blockWords + workingBlocks[3].blockWords
        
        
        blocksCombinedForStandardDiviation.append(EBBlock(wordsToUse: tempArray1, blockType: EBBlockType.Regular))
        blocksCombinedForStandardDiviation.append(EBBlock(wordsToUse: tempArray2, blockType: EBBlockType.Regular))
        
        //step 5.2 calucalte combined s.d and add to array
        var standardDiviationForEachNameInTheCombinedBlocks = Array<EBBlock>()
        standardDiviationForEachNameInTheCombinedBlocks.append(blocksCombinedForStandardDiviation[0].standardDiviation())
        standardDiviationForEachNameInTheCombinedBlocks.append(blocksCombinedForStandardDiviation[1].standardDiviation())
        
        //step 6 replace all incorrect words response times with average + 600ms
        for block in workingBlocks {
            var words = block.blockWords
            for word in words {
                if !word.getIsCorrect() {
                    word.setResponseTime(word.getResponseTime() + 0.6)
                }
            }
        }

        //step 7 calcualte average response times with incorrect values replaced
        var averageResponseTimesForEachNameInEachBlockWithIncorrectNamesResponseTimeReplaced = Array<EBBlock>()
        for block in workingBlocks {
            averageResponseTimesForEachNameInEachBlockWithIncorrectNamesResponseTimeReplaced.append(block.averageResponseTimes())
        }
        
        //step 8 calculate difference between words from negative blocks 3/6 || 4/7
        var responseTimeDifferencesBetweenNegativeBlocks = [differencesBetweenWordsInBlocks(averageResponseTimesForEachNameInEachBlockWithIncorrectNamesResponseTimeReplaced[0], block2: averageResponseTimesForEachNameInEachBlockWithIncorrectNamesResponseTimeReplaced[2], isTypeMatching: isTypesMatching), differencesBetweenWordsInBlocks(averageResponseTimesForEachNameInEachBlockWithIncorrectNamesResponseTimeReplaced[1], block2: averageResponseTimesForEachNameInEachBlockWithIncorrectNamesResponseTimeReplaced[3], isTypeMatching: isTypesMatching)]
        
        
        //step 9 devide the rp diffrences in the s.d
        var responseTimeDevidedByStandardDiviation = Array<EBBlock>()
        for i in 0..<responseTimeDifferencesBetweenNegativeBlocks.count {
            var words = Array<EBBlockWord>()
            for word in responseTimeDifferencesBetweenNegativeBlocks[i].blockWords {
                let sdBlock = standardDiviationForEachNameInTheCombinedBlocks[i]
                let wordResponseTimeDevidedBySD = word.getResponseTime() / sdBlock.getBlockWord(word.getWord())!.getResponseTime()
                var tempWord = EBBlockWord(word: word.getWord(), wordType: word.wordType)
                tempWord.setResponseTime(wordResponseTimeDevidedBySD)
                words.append(tempWord)
            }
            responseTimeDevidedByStandardDiviation.append(EBBlock(wordsToUse: words, blockType: 0))
        }
        
        
         //step 10 average the results of both blocks
        var finalNameValues = Array<EBBlockWord>()
        var block1 = responseTimeDevidedByStandardDiviation[0]
        var block2 = responseTimeDevidedByStandardDiviation[1]
        for word1 in block1.blockWords {
            if let word2 = block2.getBlockWord(word1.getWord()) {
                let finalValue = (word1.getResponseTime() + word2.getResponseTime()) / 2
                var tempWord = EBBlockWord(word: word1.getWord(), wordType: word1.wordType)
                tempWord.setResponseTime(finalValue)
                finalNameValues.append(tempWord)
            }
        }
        
        finalNameValues.sort{ $0.getResponseTime() > $1.getResponseTime() }
        
        
        //
        return finalNameValues
        
    }
    
    func differencesBetweenWordsInBlocks(block1 :EBBlock, block2: EBBlock, isTypeMatching: Bool) -> EBBlock {
        var tempWords = Array<EBBlockWord>()
        for word1 in block1.blockWords {
            if let word2 = block2.getBlockWord(word1.getWord()) {
                var substractedResponseTime:Double = 0
                if isTypeMatching {
                    substractedResponseTime = word1.getResponseTime() - word2.getResponseTime()
                } else {
                    substractedResponseTime = word2.getResponseTime() - word1.getResponseTime()
                }
                
                var tempWord = EBBlockWord(word: word1.getWord(), wordType: word1.wordType)
                tempWord.setResponseTime(substractedResponseTime)
                tempWords.append(tempWord)
            }
        }
        return EBBlock(wordsToUse: tempWords, blockType: 0)
    }
   
}
