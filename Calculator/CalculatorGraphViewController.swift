//
//  CalculatorGraphViewController.swift
//  Calculator
//
//  Created by Tulin Akdogan on 3/19/15.
//  Copyright (c) 2015 Tulin Akdogan. All rights reserved.
//

import UIKit

class CalculatorGraphViewController: UIViewController {

    var function: String = "" {
        didSet{
            //function =
            println("function = \(function)")
            updateUI()
        }
    }
    
    
    @IBOutlet weak var graphView: GraphView!{
        didSet{
            //graphView.dataSource =
            //graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: "scale:"))
        }
    }
    
    func updateUI() {
        graphView?.setNeedsDisplay()
        title = "\(function)"
        
    }

    

}
