//
//  SetGame.swift
//  Set Game
//
//  Created by Beibei Lu on 8/5/18.
//  Copyright © 2018 Seraph Technologies. All rights reserved.
//

import Foundation

struct SetGame {
    
    // MARK: Properties
    private(set) var score = 0
    private(set) var deck = [Card]()
    private(set) var board = [Card]()
    private(set) var selectedCards = [Card]()
    private(set) var hintCards = [Card]()
    var solvable: Bool {
        mutating get {
            solve()
            return !hintCards.isEmpty
        }
    }
    var selectedCardsIsASet:Bool {
        return isASet(cardsOf3: selectedCards)
    }
    
    private(set) var win:Bool = false
    
    var gameEnd:Bool {
        mutating get {
            // TODO: Check end game
            // 1. Deck empty and board empty => win
            // 2. No more possible move
            // - no solution and no matching set
            // board is full || board not full but deck is empty
            // lose
            
            if deck.isEmpty && board.isEmpty {
                win = true
                return true
            }
            if !solvable && !selectedCardsIsASet {
                if ( board.count == 24 )  || ( board.count > 0 && deck.isEmpty ) {
                    win = false
                    return true
                }
            }
            return false
        }
    }
    
    
    // MARK: Methods
    
    mutating func chooseCard(with index: Int) {
        let card = board[index]
        let isNewSelection = !selectedCards.contains(card)
        
        if selectedCards.count == 3 {
            if selectedCardsIsASet {
                print("It's a set!")
                replaceMatchedCards()
            } else { selectedCards.removeAll() }
        } else {
            if !isNewSelection { selectedCards = selectedCards.filter{ $0 != card } }
        }
        
        if isNewSelection { selectedCards.append(card) }
        
        
        
        
    }
    
    mutating func deal() {
        if selectedCardsIsASet {
            replaceMatchedCards()
        } else {
            selectedCards.removeAll()
            draw(of: 3)
        }
    }
    
    // MARK: Solver
    
    mutating func solve(){
        hintCards.removeAll()
        
        let foundCombinations = combinations(source: board, takenBy: 3)
        
        guard !foundCombinations.isEmpty else {
            return
        }
        
        var solutions = [[Card]]()
        for combination in foundCombinations {
            if isASet(cardsOf3: combination) {
                solutions.append(combination)
            }
        }
        
        guard !solutions.isEmpty else {
            return
        }
        
        let randomIndex = solutions.count.arc4random
        let solution = solutions[randomIndex]
        hintCards = solution
        
    }
    
    
    private func combinations<T>(source: [T], takenBy : Int) -> [[T]] {
        if(source.count == takenBy) {
            return [source]
        }
        
        if(source.isEmpty) {
            return []
        }
        
        if(takenBy == 0) {
            return []
        }
        
        if(takenBy == 1) {
            return source.map { [$0] }
        }
        
        var result : [[T]] = []
        
        let rest = Array(source.suffix(from: 1))
        let subCombos = combinations(source: rest, takenBy: takenBy - 1)
        result += subCombos.map { [source[0]] + $0 }
        result += combinations(source: rest, takenBy: takenBy)
        return result
    }
    
    
    // MARK: Initialization
    
    init () {
        score = 0
        // Create a new deck of 81 cards.
        cardFactory()
        deck.shuffle()
        // Deal 12 cards
        draw(of: 12)

        print("Game Starting...")
    }
    
    // MARK: Private Methods
    
    private func isASet(cardsOf3: [Card]) -> Bool {
        if cardsOf3.count != 3 { return false }
        //        return true // For testing purposes ONLY.
        var color = Int()
        var shading = Int()
        var number = Int()
        var symbol = Int()
        
        for card in cardsOf3 {
            color += card.color.rawValue
            shading += card.shading.rawValue
            number += card.number.rawValue
            symbol += card.symbol.rawValue
        }
        
        return color % 3 == 0 && shading % 3 == 0 && number % 3 == 0 && symbol % 3 == 0
    }
    
    mutating private func cardFactory() {
        for color in Color.allCases() {
            for number in Number.allCases() {
                for symbol in Symbol.allCases() {
                    for shading in Shading.allCases() {
                        let card = Card(color: color, number: number, symbol: symbol, shading: shading)
                        deck += [card]
                    }
                }
            }
        }
        assert(deck.count == 81)
    }
    
    mutating private func draw(of amount: Int) {
        for _ in 0..<amount {
            board.append(deck.removeFirst())
        }
    }
    
    mutating private func replaceMatchedCards(){
        for card in selectedCards {
            if let index = board.index(of: card) {
                if deck.isEmpty {
                    board.remove(at: index)
                } else {
                    board[index] = deck.removeFirst()
                    
                }
            }
        }
        selectedCards.removeAll()
        score += 5
        print("board: \(board.count), deck: \(deck.count) selectedCards; \(selectedCards.count)")
    }
}

// MARK: - Extensions

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            // Change `Int` in the next line to `IndexDistance` in < Swift 4.1
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

extension Int {
    var arc4random:Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

