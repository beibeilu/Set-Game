//
//  Card.swift
//  Set Game
//
//  Created by Beibei Lu on 8/5/18.
//  Copyright © 2018 Seraph Technologies. All rights reserved.
//

import Foundation

struct Card: Hashable
{
    let color:Color
    let number:Number
    let symbol:Symbol
    let shading:Shading
    
    let value: Int
    
    var hashValue: Int {return identifier}
    
    private var identifier: Int
    
    private static var identifierFactory = 0
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return
            lhs.color == rhs.color &&
                lhs.number == rhs.number &&
                lhs.symbol == rhs.symbol &&
                lhs.shading == rhs.shading
    }
    
    init(color:Color, number:Number, symbol: Symbol, shading:Shading) {
        self.color = color
        self.number = number
        self.symbol = symbol
        self.shading = shading
        self.value = color.rawValue + number.rawValue + symbol.rawValue + shading.rawValue
        self.identifier = Card.getUniqueIdentifier()
    }
}

