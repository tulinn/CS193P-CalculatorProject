//
//  CalcultorBrain.swift
//  Calculator
//
//  Created by Tulin Akdogan on 2/8/15.
//  Copyright (c) 2015 Tulin Akdogan. All rights reserved.
//

import Foundation
class CalculatorBrain{
    private enum Op{
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
    
//    var description: String{
//        get{
//            
//        }
//    }
    

    init(){
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["÷"] = Op.BinaryOperation("÷", {$1 / $0})
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["−"] = Op.BinaryOperation("−", {$1 - $0})
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        knownOps["sin"] = Op.UnaryOperation("sin", {sin($0)})
        knownOps["cos"] = Op.UnaryOperation("cos", {cos($0)})
        //knownOps["ᐩ/-"] = Op.UnaryOperation("ᐩ/-", { -$0 })
        knownOps["π"] = Op.NullaryOperation("π", {M_PI}) //is not working correctly 
        //knownOps["x"] =
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
        }
        return evaluate()
    }
    func clear(){
        opStack = []
    }
}