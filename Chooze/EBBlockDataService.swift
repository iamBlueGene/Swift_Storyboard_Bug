//
//  EBBlockDataService.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 10/1/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

private var _myBlockDataService = EBBlockDataService()

class EBBlockDataService: NSObject {
    
    private var wordsBlocks = Array<EBBlock>()
    private var goodWords = Array<String>()
    private var badWords = Array<String>()
    private var desiredNames = Array<String>()
    private var undesiredNames = Array<String>()
    
    class var sharedInstance :EBBlockDataService {
        return _myBlockDataService
    }
    
    func createBlocks(goodWords: Array<String>, badWords: Array<String>, desiredNames: Array<String>, undesiredNames: Array<String>, whichBlockToStartWith: Int) -> Array<EBBlock> {
        //Creating 7 blocks
        self.goodWords = goodWords
        self.badWords = badWords
        self.desiredNames = desiredNames
        self.undesiredNames = undesiredNames
        
        var blocks = Array<EBBlock>()
        
//        blocks.append(createWordsOnlyBlock(20))
//        blocks.append(createNamesOnlyBlock(20))
//        blocks.append(createBlock(3))
//        blocks.append(createBlock(6))
//        blocks.append(createNamesOnlyBlock(20))
//        blocks.append(createBlock(3))
//        blocks.append(createBlock(6))
        
        blocks.append(createNamesOnlyBlock(10))
        blocks.append(createWordsOnlyBlock(10))
        blocks.append(createBlock(1))
        blocks.append(createBlock(2))
        blocks.append(createNamesOnlyBlock(10))
        blocks.append(createBlock(1))
        blocks.append(createBlock(2))
        
        return blocks
    }
    
    private func createWordsOnlyBlock(wordsAmount: Int) -> EBBlock {
        var block = EBBlock(wordsToUse: getWords(wordsAmount), blockType: EBBlockType.WordsOnly)
        return block
    }
    
    private func createNamesOnlyBlock(wordsAmount: Int) -> EBBlock {
        var block = EBBlock(wordsToUse: getNames(wordsAmount), blockType: EBBlockType.NamesOnly)
        return block
    }
    
    private func createBlock(howManyTimesEachWord: Int) -> EBBlock {
        var words = Array<EBBlockWord>()
        let totalWordsInBlock = (self.goodWords.count * howManyTimesEachWord) * 4
        //first add two random words
        words += self.getRandomWords(2)
        var tempWords = getWords((totalWordsInBlock - 2) / 2)
        tempWords += getNames((totalWordsInBlock - 2) / 2)
        
        tempWords = ChoozeUtils.shuffle(tempWords)
        words += tempWords
        
        let block = EBBlock(wordsToUse: words, blockType: EBBlockType.Regular)
        return block
    }
    
    private func getRandomWords(amount :Int) -> Array<EBBlockWord> {
        var words = Array<EBBlockWord>()
        var whichType = 0
        for i in 0..<amount {
            whichType = Int(arc4random_uniform(2))
            var word:EBBlockWord
            if whichType == 0 {
                let whichWord = Int(arc4random_uniform(UInt32(self.goodWords.count)));
                word = EBBlockWord(word: self.goodWords[whichWord], wordType: "Good Words")
            }
            else {
                let whichWord = Int(arc4random_uniform(UInt32(self.badWords.count)));
                word = EBBlockWord(word: self.badWords[whichWord], wordType: "Bad Words")
            }
            words.append(word)
        }
        
        return words
    }
    
    private func getRandomNames(amount: Int) -> Array<EBBlockWord> {
        var words = Array<EBBlockWord>()
        var whichType = 0
        for i in 0..<amount {
            whichType = Int(arc4random_uniform(2))
            var word:EBBlockWord
            if whichType == 0 {
                let whichWord = Int(arc4random_uniform(UInt32(self.desiredNames.count)));
                word = EBBlockWord(word: self.desiredNames[whichWord], wordType: "Desired Names")
            }
            else {
                let whichWord = Int(arc4random_uniform(UInt32(self.undesiredNames.count)));
                word = EBBlockWord(word: self.undesiredNames[whichWord], wordType: "Undesired Names")
            }
            words.append(word)
        }
        
        return words
    }
    
    private func getWords(amount :Int) -> Array<EBBlockWord> {
        var words = Array<EBBlockWord>()
        let howManyTimesEachWord = amount / (self.goodWords.count + self.badWords.count)
        let howManyWords = self.goodWords.count + self.badWords.count
        
        for i in 0..<self.goodWords.count {
            for j in 0..<howManyTimesEachWord {
                words.append(EBBlockWord(word: self.goodWords[i], wordType: "Good Words") )
            }
        }
        
        for i in 0..<self.badWords.count {
            for j in 0..<howManyTimesEachWord {
                words.append(EBBlockWord(word: self.badWords[i], wordType: "Bad Words") )
            }
        }
        
        let howManyLeftToAdd = amount - words.count
        words += getRandomWords(howManyLeftToAdd)
        
        words = ChoozeUtils.shuffle(words)
        return words
        
    }
    
    private func getNames(amount :Int) -> Array<EBBlockWord> {
        var words = Array<EBBlockWord>()
        let howManyTimesEachWord = amount / (self.desiredNames.count + self.undesiredNames.count)
        let howManyWords = self.desiredNames.count + self.undesiredNames.count
        
        for i in 0..<self.desiredNames.count {
            for j in 0..<howManyTimesEachWord {
                words.append(EBBlockWord(word: self.desiredNames[i], wordType: "Desired Names") )
            }
        }
        
        for i in 0..<self.undesiredNames.count {
            for j in 0..<howManyTimesEachWord {
                words.append(EBBlockWord(word: self.undesiredNames[i], wordType: "Undesired Names") )
            }
        }
        
        let howManyLeftToAdd = amount - words.count
        words += getRandomNames(howManyLeftToAdd)
        
        words = ChoozeUtils.shuffle(words)
        return words
    }
}
