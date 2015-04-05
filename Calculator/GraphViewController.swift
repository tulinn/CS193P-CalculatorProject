//
//  CalculatorGraphViewController.swift
//  Calculator
//
//  Created by Tulin Akdogan on 3/19/15.
//  Copyright (c) 2015 Tulin Akdogan. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphViewDataSource {

    var brain = CalculatorBrain()
    
    var function: String = "" {
        didSet{
            // println("function = \(function)")
            updateUI()
        }
    }
    
    var program: AnyObject{ // guaranteed to be a PropertyList
        get{
            return brain.program
        }
        set{
            brain.program = newValue
        }
    }
    
    func f(x: CGFloat) -> CGFloat?{
        let symbol = "M"
        var value = Double(x)
        if function.lowercaseString.rangeOfString(symbol) != nil{
            if let result = brain.setSymbol(symbol, value: value){
                return CGFloat(result)
            }
        }
        else{
            if let result = brain.evaluate(){
                return CGFloat(result)
            }
        }
        return nil
    }
    
    @IBOutlet weak var graphView: GraphView!{
        didSet{
            graphView.dataSource = self
            //graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: "scale:"))
        }
    }
    
    func updateUI() {
        graphView?.setNeedsDisplay()
        title = "\(function)"
    }
}
