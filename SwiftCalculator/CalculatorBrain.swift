//
//  CalculatorBrain.swift
//  SwiftCalculator
//
//  Created by Alexander Nelson on 5/29/16.
//  Copyright © 2016 JetWolfe Labs. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return operand
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                default:
                    <#code#>
                }
            }
        }
        
    }
    
    
    private var operationStack = [Op]()
    private var knownOperations = [String:Op]()
    
    init() {
        knownOperations["✖️"] = Op.BinaryOperation("✖️") {$0 * $1}
        knownOperations["➗"] = Op.BinaryOperation("➗") {$1 / $0}
        knownOperations["➖"] = Op.BinaryOperation("➖") {$1 - $0}
        knownOperations["➕"] = Op.BinaryOperation("➕") {$0 + $1}
        knownOperations["√"] = Op.UnaryOperation("√", sqrt)
    }
    
    private func recursiveEvaluation(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops .isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = recursiveEvaluation(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = recursiveEvaluation(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = recursiveEvaluation(op1Evaluation.remainingOps)
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = recursiveEvaluation(operationStack)
        return result
        
    }
    
    func pushOperand(operand: Double) {
        operationStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) {
        if let operation = knownOperations[symbol] {
            operationStack.append(operation)
        }
        return evaluate()
    }
}
