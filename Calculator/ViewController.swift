//
//  ViewController.swift
//  Calculator
//
//  Created by Tulin Akdogan on 1/25/15.
//  Copyright (c) 2015 Tulin Akdogan. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var displayHistory: UILabel!
    
    var userInTheMiddleOfTypingNumber: Bool = false
    var brain = CalculatorBrain()
    var theNumberIsFloating: Bool = false
    var opDisplayInUse: Bool = false
    var checkValue: Double?
    
    @IBAction func appendDigit(sender: UIButton) { //appends digit by digit to the display
        let digit = sender.currentTitle!
        if userInTheMiddleOfTypingNumber{
            display.text = display.text! + digit
        }
        else{
            display.text = digit
            userInTheMiddleOfTypingNumber = true
        }
    }
    
    @IBAction func getM(sender: UIButton) {
        if let symbol = sender.currentTitle{
            brain.pushOperand(symbol)
        }
    }
    
    @IBAction func setM(sender: UIButton) {
        if userInTheMiddleOfTypingNumber{
            enter()
        }
        if let symbol = sender.currentTitle{
            if let value = brain.getTheLastOperand() {
                brain.setSymbol(symbol, value: value)
            }
        }
    }
    
    @IBAction func backspace(sender: UIButton) { //deletes a digit if the display is not empty. This part has nothing to do with the brain as the number is still in the process of being created.
        if userInTheMiddleOfTypingNumber{
            if display.text == ""{
                userInTheMiddleOfTypingNumber = false
                display.text = "0"
            }
            else{
                var wrongNums: String = display.text!
                var corrected: String = dropLast(wrongNums)
                display.text = corrected
            }
        }
    }
    
    @IBAction func changeSign(sender: UIButton) { //again in this part the number is still not completed, user is still in the middle of typing. Therefore has nothing to do with brain.
        var current: String = display.text!
        if current[current.startIndex] == "−" {
            current = dropFirst(current)
            display.text = current
        }
        else{
            display.text = "−" + current
        }
    }
    
    @IBAction func clear() { //this part clears both labels display and displayHistory. It also clears the opStack in Brain.
        displayHistory.text = "0"
        display.text = "0"
        brain.clear()
        opDisplayInUse = false
        userInTheMiddleOfTypingNumber = false
        theNumberIsFloating = false
    }
    
    @IBAction func operate(sender: UIButton) { //this method is processed when one of the operations is pressed.
        var currText = displayHistory.text!
        let newText = currText.stringByReplacingOccurrencesOfString("=", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil) // first, we remove the previous "=" in the displayHistory
        displayHistory.text = newText
        
        if userInTheMiddleOfTypingNumber{
            enter()
        }
        if let operation = sender.currentTitle{
            checkValue = brain.performOperation(operation)
            displayValue = checkValue
            if let result = checkValue { //if not nil
                displayHistory.text = brain.description! + " ="
            }
        }
    }
    
    @IBAction func float(sender: UIButton) { //this method has nothing to do with the brain part as the user is still in the middle of typing number.
        if theNumberIsFloating == false{
            theNumberIsFloating = true
            if userInTheMiddleOfTypingNumber {
                display.text = display.text! + "."
            }
            else{
                display.text = "."
                userInTheMiddleOfTypingNumber = true
            }
        }
    }
    
    @IBAction func enter() {
        userInTheMiddleOfTypingNumber = false
        theNumberIsFloating = false
        //brain.pushOperand(displayValue!)

        if let result = displayValue{ //if displayValue is not nil
            brain.pushOperand(result)
        }
        else{
            clear()
        }

        displayHistory.text = brain.description
    }
    
    var displayValue: Double?{
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            println("newVal is \(newValue)")
            if let value = newValue{
                display.text = "\(value)"
            }
            else{
                println("about to clear")
                clear()
            }
        }
    }
}

