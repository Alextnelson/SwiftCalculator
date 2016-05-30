//
//  CalculatorViewController.swift
//  SwiftCalculator
//
//  Created by Alexander Nelson on 5/17/16.
//  Copyright © 2016 Jetwolfe Labs. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    @IBOutlet weak var calculatorDisplay: UILabel!
    var operandStack = Array<Double>()
    var userIsInTheMiddleOfTyping = false

    var calculatorDisplayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(calculatorDisplay.text!)!.doubleValue
        }

        set {
            calculatorDisplay.text = "\(newValue)"
            userIsInTheMiddleOfTyping = false
        }
    }


    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        print("Digit = \(digit)")

        if userIsInTheMiddleOfTyping {
            calculatorDisplay.text = calculatorDisplay.text! + digit
        } else {
            calculatorDisplay.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }

    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            enter()
        }
        switch operation {
            case "✖️": performOperation {$0 * $1}
            case "➗": performOperation {$1 / $0}
            case "➖": performOperation {$1 - $0}
            case "➕": performOperation {$0 + $1}
            case "√": performOneValueOperation { sqrt($0)}
        default: break
        }
    }
    

    @IBAction func enter() {
        userIsInTheMiddleOfTyping = false
        operandStack.append(calculatorDisplayValue)
        print("Digits Stack = \(operandStack)")
    }

    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            calculatorDisplayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }

    func performOneValueOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            calculatorDisplayValue = operandStack.removeLast()
            enter()
        }
    }

}