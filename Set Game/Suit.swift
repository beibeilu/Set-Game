//
//  Suit.swift
//  Set Game
//
//  Created by Beibei Lu on 8/5/18.
//  Copyright © 2018 Seraph Technologies. All rights reserved.
//

import Foundation
import UIKit

enum Color:Int, EnumCollection
{
    case colorA = 0, colorB, colorC
}

enum Number:Int, EnumCollection
{
    case one = 0, two, three
}

enum Symbol: Int, EnumCollection
{
    case circle = 0, square, triangle
}
enum Shading:Int, EnumCollection
{
    case fill = 0, outline, stripe
}

public protocol EnumCollection: Hashable {
    static func allCases() -> AnySequence<Self>
    static var allValues: [Self] { get }
}

public extension EnumCollection {
    
    public static func allCases() -> AnySequence<Self> {
        return AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            return AnyIterator {
                let current: Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: self, capacity: 1) { $0.pointee } }
                guard current.hashValue == raw else {
                    return nil
                }
                raw += 1
                return current
            }
        }
    }
    
    public static var allValues: [Self] {
        return Array(self.allCases())
    }
}
