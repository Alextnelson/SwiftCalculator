//
//  CalculatorViewController.swift
//  SwiftCalculator
//
//  Created by Alexander Nelson on 5/17/16.
//  Copyright © 2016 JetWolfe Labs. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    @IBOutlet weak var calculatorDisplay: UILabel!
    var brain = CalculatorBrain()
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
        if userIsInTheMiddleOfTyping {
            enter()
        }
        if let operation = sender.currentTitle! {
            if let result = brain.performOperation(operation) {
                calculatorDisplayValue = result
            } else {
                calculatorDisplayValue = 0
            }
        }

    }
    

    @IBAction func enter() {
        userIsInTheMiddleOfTyping = false
        if let result = brain.pushOperand(calculatorDisplayValue) {
            calculatorDisplayValue = result
        } else {
            calculatorDisplayValue
        }
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