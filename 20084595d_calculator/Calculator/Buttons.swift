//
//  Buttons.swift
//  Calculator
//
//  Created by HAO Jiadong on 11/10/2022.
//

import Foundation
import SwiftUI

enum CalcuButton:String{
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case add = "+"
    case subtract = "-"
    case multiply = "x"
    case divide = "/"
    case equal = "="
    case clear = "AC"
    case decimal = "."
    case percent = "%"
    case negative = "+/-"
    case sin = "sin"
    case cos = "cos"
    case pi = "π"
    case e = "e"
    case ln = "ln"
    case square = "x²"
    case tan = "tan"
    case A = "A"
    case B = "B"
    case C = "C"
    case D = "D"
    case E = "E"
    case F = "F"
    case leftBracket = "("
    case rightBracket = ")"
    
    var buttonColor: Color{
        switch self{
        case .add, .subtract, .multiply, .divide, .equal:
            return .orange
        case .clear, .negative, .percent, .sin, .cos, .pi, .e,.square,.tan,.ln,.leftBracket,.rightBracket:
            return Color(.lightGray)
        default:
            return Color(UIColor(red: 55/255.0, green:55/255.0,blue:55/255.0,alpha: 1))
        }
    }
    
    var isDigit: Bool{
        switch self{
        case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero, .decimal,.A,.B,.C,.D,.E,.F:
            return true
        default:
            return false
        }
    }
}
