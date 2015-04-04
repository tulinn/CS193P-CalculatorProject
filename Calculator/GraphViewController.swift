//
//  CalculatorGraphViewController.swift
//  Calculator
//
//  Created by Tulin Akdogan on 3/19/15.
//  Copyright (c) 2015 Tulin Akdogan. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphViewDataSource {

    var function: String = "" {
        didSet{
            var program: String = brain.program as String
            var functions = program.componentsSeparatedByString(",")
            function = functions.removeLast()
            println("function = \(function)")
            updateUI()
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
        return nil
    }
    
    var brain = CalculatorBrain()
    
    @IBOutlet weak var graphView: GraphView!{
        didSet{
            //graphView.dataSource = brain.program
            //graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: "scale:"))
        }
    }
    
//    func functionValueForPixel(sender: GraphView) -> Double?{
//        //return
//    }
    
    func updateUI() {
        graphView?.setNeedsDisplay()
        title = "\(function)"
        
    }

    

}
