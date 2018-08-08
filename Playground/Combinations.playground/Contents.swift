//: Playground - noun: a place where people can play

import UIKit
import Foundation

var arr = [1, 2, 3, 4, 5]

func combinations<T>(source: [T], takenBy : Int) -> [[T]] {
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


combinations(source: arr, takenBy: 3)

func factorial(_ n: Int) -> Int {
    var n = n
    var result = 1
    while n > 1 {
        result *= n
        n -= 1
    }
    return result
}

func permutations(_ n: Int, _ k: Int) -> Int {
    var n = n
    var answer = n
    for _ in 1..<k {
        n -= 1
        answer *= n
    }
    return answer
}

func combinations(_ n: Int, choose k: Int) -> Int {
    return permutations(n, k) / factorial(k)
}


combinations(arr.count, choose: 3)

