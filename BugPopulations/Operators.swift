//
//  Operators.swift
//  Extension for factorial and exponent
//
//  Created by Jeff Terry on 8/25/22.
//

import SwiftUI

infix operator ↑: MultiplicationPrecedence
extension Double {
    static func ↑ (left: Double, right: Double) -> Double {
        return pow(left, right)
    }
}


postfix operator ❗️
extension Double {
    static postfix func ❗️(left: Double) -> Double {
        var factorial :Double = 0.0
        if (left != 0){
            factorial = left*tgamma(left)
        }
        else {
            factorial = 1.0
        }
        return factorial
    }
}
extension Int {
    static postfix func ❗️(left: Int) -> Int {
        var factorial :Int = 0
        if (left != 0){
            factorial = left*(Int(tgamma(Double(left))))
        }
        else {
            factorial = 1
        }
        return factorial
    }
}
extension Float {
    static postfix func ❗️(left: Float) -> Float {
        var factorial :Float = 0.0
        if (left != 0){
            factorial = left*tgamma(left)
        }
        else {
            factorial = 1.0
        }
        return factorial
    }
}
