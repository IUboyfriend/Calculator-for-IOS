//
//  CalculatorViewModel.swift
//  Calculator
//
//  Created by HAO Jiadong on 11/10/2022.
//

import Foundation

class CalculatorViewModel : ObservableObject{
    
    @Published var value = "0"
    @Published var mode = ["DEC", "BIN", "HEX"]
    @Published var selectedMode = "DEC" {
        didSet{
            switch selectedMode{
            case "BIN":
                value = String(Int(value) ?? 0, radix:2)
            case "HEX":
                value = String(Int(value) ?? 0, radix:16,uppercase: true)
            default:
                value = "\(accumulator)"
            }
        }
        willSet{
            value = String(format:"%.0f",accumulator)
        }
    }
    
    private var isUserEnteringNumber = false
    private var pendingFirstLevelOperation: PendingBinaryOperation?
    private var pendingSecondLevelOperation: PendingBinaryOperation?
    private var firstLevelResult:Double? = 0
    private var secondLevelResult:Double? = 0
    private var pendingFirstLevelOperationInBracket: PendingBinaryOperation?
    private var pendingSecondLevelOperationInBracket: PendingBinaryOperation?
    private var firstlevelResultInBracket:Double? = 0
    private var secondLevelResultInBracket:Double? = 0
    private var isBracketed = false
    
    let buttons: [[CalcuButton]] = [
        [.pi, .e, .sin,.cos],
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal]]
    
    let binButtons: [[CalcuButton]] = [
        [.add,.subtract,.multiply,.divide],
        [.zero, .one, .equal,.clear]]
    
    let hexButtons: [[CalcuButton]] = [
        [.clear,.equal],
        [.add,.subtract,.multiply,.divide],
        [.seven, .eight, .nine,.F],
        [.four, .five, .six, .E],
        [.one, .two, .three, .D],
        [.zero, .A, .B, .C]
    ]
    
    let landscapeButtons: [[CalcuButton]] = [
        [.seven, .eight, .nine, .divide,.clear,.pi,.ln],
        [.four, .five, .six, .multiply,.cos,.e,.tan],
        [.one, .two, .three, .subtract,.sin,.negative,.square],
        [.zero, .decimal, .add, .equal,.percent,.leftBracket,.rightBracket]]
    
    let lanscapeHexButtons: [[CalcuButton]] = [
        [.add,.subtract,.multiply,.divide],
        [.C,.D, .E,.F,.clear,.equal],
        [  .six,.seven,.eight,.nine,.A, .B],
        [.zero,.one, .two, .three,.four, .five]
    ]
    
    private var accumulator: Double{
        set{
            if newValue == 0{
                self.value = "0"
            }
            else{
                if selectedMode == "BIN"{
                    self.value = String(Int(newValue), radix: 2)
                }
                else if selectedMode == "DEC"{
                    self.value = "\(newValue)"
                }
                else if selectedMode == "HEX"{
                    self.value = String(Int(newValue), radix: 16).uppercased()
                }
            }
        }
        get{
            if selectedMode == "BIN"{
                return Double(Int(value, radix:2) ?? 0)
            }
            if selectedMode == "HEX"{
                return Double(Int(value, radix: 16) ?? 0)
            }
            return Double(value) ?? 0
        }
        
    }
    
    
    private var operations: Dictionary<String, Operation> = [
        CalcuButton.pi.rawValue: Operation.constant(Double.pi),
        CalcuButton.e.rawValue: Operation.constant(M_E),
        CalcuButton.add.rawValue: Operation.binaryOperation({$0+$1}),
        CalcuButton.subtract.rawValue: Operation.binaryOperation({$0-$1}),
        CalcuButton.multiply.rawValue: Operation.binaryOperation({$0*$1}),
        CalcuButton.divide.rawValue: Operation.binaryOperation({$0/$1}),
        CalcuButton.sin.rawValue: Operation.unaryOperation(sin),
        CalcuButton.cos.rawValue: Operation.unaryOperation(cos),
        CalcuButton.negative.rawValue:Operation.unaryOperation({-$0}),
        CalcuButton.percent.rawValue: Operation.unaryOperation({$0*0.01}),
        CalcuButton.ln.rawValue: Operation.unaryOperation({log($0)/log(M_E)}),
        CalcuButton.tan.rawValue: Operation.unaryOperation(tan),
        CalcuButton.square.rawValue:Operation.unaryOperation({$0*$0}),
        CalcuButton.equal.rawValue: Operation.equals,
        CalcuButton.clear.rawValue: Operation.clear,
        CalcuButton.leftBracket.rawValue:Operation.bracket,
        CalcuButton.rightBracket.rawValue:Operation.bracket
    ]
    
    private enum Operation{
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
        case bracket
        case clear
    }
    
    private struct PendingBinaryOperation{
        let function: (Double,Double) -> Double
        let firstOperand: Double
        func perform(with secondOperand: Double) -> Double{
            return function(firstOperand, secondOperand)
        }
    }
    
    
    
    func didTap(button:CalcuButton){
        if button.isDigit == true{
            digitPressed(button: button)
        }
        else{
            operationPressed(button: button)
        }
    }

    func digitPressed(button: CalcuButton){
        let number = button.rawValue
        if(isUserEnteringNumber == false && number != "0" ){
            isUserEnteringNumber = true;
            self.value = "\(number)"
        }
        else if (isUserEnteringNumber == false && number == "0")
        {
            self.value = "\(number)"
        }
        else{
            self.value = "\(self.value)\(number)"
        }
    }
    
    func operationPressed(button: CalcuButton)
    {
        isUserEnteringNumber = false
        if let operation = operations[button.rawValue]{
            switch operation{
            case .constant(let resultValue):
                accumulator = resultValue
            case .unaryOperation(let function):
                accumulator = function(accumulator)
            case .binaryOperation(let function):
                if(isBracketed == false)
                {
                    if (button.rawValue == "x" || button.rawValue == "/"){
                        if pendingFirstLevelOperation == nil{
                            pendingFirstLevelOperation = PendingBinaryOperation(function:function,firstOperand:accumulator)
                        }
                        else{
                            firstLevelResult = pendingFirstLevelOperation!.perform(with: accumulator)
                            pendingFirstLevelOperation = PendingBinaryOperation(function: function, firstOperand: firstLevelResult!)
                        }
                     
                    }
                    else if (button.rawValue == "+" || button.rawValue == "-") && pendingFirstLevelOperation != nil{
                        firstLevelResult = pendingFirstLevelOperation!.perform(with: accumulator)
                        pendingFirstLevelOperation = nil
                        if pendingSecondLevelOperation == nil{
                            pendingSecondLevelOperation = PendingBinaryOperation(function: function, firstOperand: firstLevelResult!)
                        }
                        else{
                            secondLevelResult = pendingSecondLevelOperation!.perform(with: firstLevelResult!)
                            pendingSecondLevelOperation = PendingBinaryOperation(function: function, firstOperand: secondLevelResult!)
                        }
                        
                    }
                    else if (button.rawValue == "+" || button.rawValue == "-") && pendingFirstLevelOperation == nil{
                            if pendingSecondLevelOperation == nil{
                                pendingSecondLevelOperation = PendingBinaryOperation(function: function, firstOperand: accumulator)
                            }
                            else{
                                secondLevelResult = pendingSecondLevelOperation!.perform(with: accumulator)
                                pendingSecondLevelOperation = PendingBinaryOperation(function: function, firstOperand: secondLevelResult!)
                            }
                    }
  
                }
                else if isBracketed == true{
                    
                    if (button.rawValue == "x" || button.rawValue == "/"){
                        if pendingFirstLevelOperationInBracket == nil{
                            pendingFirstLevelOperationInBracket = PendingBinaryOperation(function:function,firstOperand:accumulator)
                        }
                        else{
                            firstlevelResultInBracket = pendingFirstLevelOperationInBracket!.perform(with: accumulator)
                            pendingFirstLevelOperationInBracket = PendingBinaryOperation(function: function, firstOperand: firstlevelResultInBracket!)
                        }
                     
                    }
                    else if (button.rawValue == "+" || button.rawValue == "-") && pendingFirstLevelOperationInBracket != nil{
                        firstlevelResultInBracket = pendingFirstLevelOperationInBracket!.perform(with: accumulator)
                        pendingFirstLevelOperationInBracket = nil
                        if pendingSecondLevelOperationInBracket == nil{
                            pendingSecondLevelOperationInBracket = PendingBinaryOperation(function: function, firstOperand: firstlevelResultInBracket!)
                        }
                        else{
                            secondLevelResultInBracket = pendingSecondLevelOperationInBracket!.perform(with: firstlevelResultInBracket!)
                            pendingSecondLevelOperationInBracket = PendingBinaryOperation(function: function, firstOperand: secondLevelResultInBracket!)
                        }
                        
                    }
                    else if (button.rawValue == "+" || button.rawValue == "-") && pendingFirstLevelOperationInBracket == nil{
                            if pendingSecondLevelOperationInBracket == nil{
                                pendingSecondLevelOperationInBracket = PendingBinaryOperation(function: function, firstOperand: accumulator)
                            }
                            else{
                                secondLevelResultInBracket = pendingSecondLevelOperationInBracket!.perform(with: accumulator)
                                pendingSecondLevelOperationInBracket = PendingBinaryOperation(function: function, firstOperand: secondLevelResultInBracket!)
                            }
                    }
                }
                
            case .equals:
                if pendingFirstLevelOperation == nil && pendingSecondLevelOperation == nil {
                    accumulator = 0
                }
                else if pendingFirstLevelOperation == nil && pendingSecondLevelOperation != nil{
                    accumulator = pendingSecondLevelOperation!.perform(with: accumulator)
                    clear()
                }
                else if pendingFirstLevelOperation != nil && pendingSecondLevelOperation == nil{
                    accumulator = pendingFirstLevelOperation!.perform(with: accumulator)
                    clear()
                }
                else if pendingFirstLevelOperation != nil && pendingSecondLevelOperation != nil{
                    firstLevelResult = pendingFirstLevelOperation!.perform(with: accumulator)
                    accumulator = pendingSecondLevelOperation!.perform(with: firstLevelResult!)
                    clear()
                }
                
                
            case .bracket:
                if(button.rawValue == "(")
                {
                    isBracketed = true
                }
                else if(button.rawValue == ")")
                {
                    
                    isBracketed = false
                    
                    if pendingFirstLevelOperationInBracket == nil && pendingSecondLevelOperationInBracket == nil {
                        accumulator = 0
                    }
                    else if pendingFirstLevelOperationInBracket == nil && pendingSecondLevelOperationInBracket != nil{
                        accumulator = pendingSecondLevelOperationInBracket!.perform(with: accumulator)
                        clearBracket()
                    }
                    else if pendingFirstLevelOperationInBracket != nil && pendingSecondLevelOperationInBracket == nil{
                        accumulator = pendingFirstLevelOperationInBracket!.perform(with: accumulator)
                        clearBracket()
                    }
                    else if pendingFirstLevelOperationInBracket != nil && pendingSecondLevelOperationInBracket != nil{
                        firstlevelResultInBracket = pendingFirstLevelOperationInBracket!.perform(with: accumulator)
                        accumulator = pendingSecondLevelOperationInBracket!.perform(with: firstlevelResultInBracket!)
                        clearBracket()
                    }
                }
                
                
            case .clear:
                self.value="0"
                clear()
            }
        }
    }
    
    
    func clear (){
        pendingFirstLevelOperation = nil
        pendingSecondLevelOperation = nil
        pendingFirstLevelOperationInBracket = nil
        pendingSecondLevelOperationInBracket = nil
        
    }
    
    func clearBracket(){
        pendingFirstLevelOperationInBracket = nil
        pendingSecondLevelOperationInBracket = nil
    }
    
    
    
}
