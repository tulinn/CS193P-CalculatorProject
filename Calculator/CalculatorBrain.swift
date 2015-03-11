//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Tulin Akdogan on 2/8/15.
//  Copyright (c) 2015 Tulin Akdogan. All rights reserved.
//

import Foundation
class CalculatorBrain{
    private enum Op: Printable{
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case NullaryOperation(String, () -> Double)
        case Variable(String)
        var description: String{
            get{
                switch self{
                case .Operand(let operand):
                    return "\(operand)"
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .NullaryOperation(let symbol, _):
                    return symbol
                case .Variable(let symbol):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    private var variableValues: Dictionary<String,Double> = [String: Double]()
    
    func setSymbol(symbol: String, value: Double) {
        variableValues[symbol] = value
    }
    
    func getTheLastOperand() -> Double?{
        if !opStack.isEmpty {
            let value = opStack.removeLast()
            switch value{
            case .Operand(let operand):
                return operand
            default: break
            }
        }
        return nil
    }
    
    var description: String?{
        get{
            var stackCopy = opStack
            //println(stackCopy)
            if let result = get(stackCopy).result{
                return result
            }
            return nil
        }
    }

    private func get(ops: [Op]) -> (result: String?, remainingOps: [Op]){
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op{
            case .Operand(let operand):
                return ("\(operand)", remainingOps)
            case .UnaryOperation(let symbol, _):
                let operandEval = get(remainingOps) //gets the operand
                if let operand = operandEval.result{
                    return (symbol + "(" + operand + ")", operandEval.remainingOps)
                }
            case .BinaryOperation(let symbol, _):
            //historical order with the oldest at the beginning of the string and the most recently pushed/performed at the end, that is why op2 comes before op1 when producing the result
    
                let op1Eval = get(remainingOps)
                if let op1 = op1Eval.result{
                    let op2Eval = get(op1Eval.remainingOps)
                    if let op2 = op2Eval.result{
                        var result = ""
                        if symbol == "×" || symbol == "÷"{ //to control the parentheses
                            if PlusOrMinusExist(op1) && PlusOrMinusExist(op2){
                                result = "(" + op2 + ")" + symbol + "(" + op1 + ")"
                            }
                            else if PlusOrMinusExist(op1){
                                result = op2 + symbol + "(" + op1 + ")"
                            }
                            else if PlusOrMinusExist(op2){
                                result = "(" + op2  + ")" + symbol + op1
                            }
                            else{
                                result = op2 + symbol + op1
                            }
                        }
                        else{
                            result = op2 + symbol + op1
                        }
                        return (result, op2Eval.remainingOps)
                    }
                }
            case .NullaryOperation(let symbol, _):
                return (symbol, remainingOps)
            case .Variable(let symbol):
                if let operand = variableValues[symbol]{ //if exists in the variableValues dictionary return the corresponding value
                    return (symbol, remainingOps)
                }
                else{ //else return nil
                    return (nil, remainingOps)
                }
            }
        }
        return (nil,ops)
    }
    
    func PlusOrMinusExist(operation:String) -> Bool{
        //println("operation = \(operation)")
        if operation.lowercaseString.rangeOfString("+") != nil || operation.lowercaseString.rangeOfString("−") != nil{
            return true
        }
        else{
            return false
        }
    }
    
    init(){
        func learnOp(op: Op){ // this function saves repetitive typing for storing value in dictionary
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *)) // same as typing: knownOps["×"] = Op.BinaryOperation("×", *)
        learnOp(Op.BinaryOperation("÷", {$1 / $0}))
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−", {$1 - $0}))
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("sin", {sin($0)}))
        learnOp(Op.UnaryOperation("cos", {cos($0)}))
        learnOp(Op.NullaryOperation("π", {M_PI}))
        learnOp(Op.Variable("M"))
        //knownOps["ᐩ/-"] = Op.UnaryOperation("ᐩ/-", { -$0 })
    }
    
//    var program: AnyObject{ //guaranteed to be a property
//        get{
//            var returnValue = Array<String>()
//            for op in opStack{
//                returnValue.append(op.description)
//            }
//            return returnValue
//        }
//        set{
//            if let opSymbols = newValue as? Array<String>{
//                var newOpstack = [op]()
//                for opSymbol in opSymbols{
//                    if let op = knownOps[opSymbol]{
//                        newOpstack.append(op)
//                    }
//                    else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue{
//                        newOpstack.append(.operand(operand))
//                    }
//                }
//                opStack = newOpstack
//            }
//        }
//    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]){ // evaluates recursively if the op is not an operand
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op{
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEval = evaluate(remainingOps) //gets the operand
                if let operand = operandEval.result{
                    return (operation(operand), operandEval.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Eval = evaluate(remainingOps)
                if let op1 = op1Eval.result{
                    let op2Eval = evaluate(op1Eval.remainingOps)
                    if let op2 = op2Eval.result{
                        return (operation(op1, op2), op2Eval.remainingOps)
                    }
                }
            case .NullaryOperation(_, let operation):
                return (operation(), remainingOps)
            case .Variable(let symbol):
                if let operand = variableValues[symbol]{ //if exists in the variableValues dictionary return the corresponding value
                    return (operand, remainingOps)
                }
                else{ //else return nil
                    return (nil, remainingOps)
                }
            }
        }
        return (nil,ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainingOps) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainingOps) left over")
        //println("result is \(result)")
        return result
    }
    
    func pushOperand(operand: Double) -> Double?{
        //println("in pushOperand")
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(symbol: String) -> Double?{
        opStack.append(Op.Variable(symbol))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double?{
        //println("in performOperation")
        if let operation = knownOps[symbol]{ //if not nil
            opStack.append(operation)
            return evaluate()
        }
        else{
            return nil
        }
    }
    
    func clear(){
        opStack = []
        variableValues = [String: Double]()
    }

    
    
    
// this function is not needed anymore
//    func displayStack() -> String{
//        let stringRepresentation = ", ".join(opStack.map({ "\($0)" })) // map method for arrays in this case convert an array with int values into an array with string values
//        return stringRepresentation
//    }


}