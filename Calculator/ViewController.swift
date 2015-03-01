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
    @IBOutlet weak var opDisplay: UILabel!
    
    var userInTheMiddleOfTypingNumber: Bool = false
    var brain = CalculatorBrain()
    var theNumberIsFloating: Bool = false
    var opDisplayInUse: Bool = false
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userInTheMiddleOfTypingNumber{
            display.text = display.text! + digit
        }
        else{
            display.text = digit
            userInTheMiddleOfTypingNumber = true
        }
    }
    
    @IBAction func backspace(sender: UIButton) {
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
    
    @IBAction func changeSign(sender: UIButton) {
        var current: String = display.text!
        if current[current.startIndex] == "−" {
            current = dropFirst(current)
            display.text = current
        }
        else{
            display.text = "−" + current
        }
    }
    
    @IBAction func clear(sender: UIButton) {
        opDisplay.text = "0"
        display.text = "0"
        brain.clear()
        opDisplayInUse = false
        userInTheMiddleOfTypingNumber = false
        theNumberIsFloating = false
    }
    
    @IBAction func operate(sender: UIButton) {
        //println(sender.currentTitle)
        if userInTheMiddleOfTypingNumber{
            enter()
        }
        opDisplay.text = opDisplay.text! + " " + sender.currentTitle!
        if let operation = sender.currentTitle{
            if let result = brain.performOperation(operation){
                displayValue = result
            }else{
                displayValue = 0
            }
        }
        opDisplay.text = opDisplay.text! + " " + display.text! + " ="
    }
    
    @IBAction func float(sender: UIButton) {
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
        if opDisplayInUse{
            opDisplay.text = opDisplay.text! + " ↵ " + display.text!
        }
        else{
            opDisplay.text = display.text!
            opDisplayInUse = true
        }
        brain.pushOperand(displayValue)
//        if let result = brain.pushOperand(displayValue) {
//            displayValue = result
//        } else{
//            displayValue = nil
//        }
    }
    
    var displayValue: Double{
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
//            if newValue != nil{
//                display.text = "\(newValue)"
//            }
//            else{
//                clear()
//            }
        }
    }
}

