//
//  GraphView.swift
//  Calculator
//
//  Created by Tulin Akdogan on 3/18/15.
//  Copyright (c) 2015 Tulin Akdogan. All rights reserved.
//

import UIKit

// delegation protocol (defines what the GraphView wants the Controller to take care of)
// GraphView needs the function, takes x as parameter and returns y
protocol GraphViewDataSource: class{
    func f(x: CGFloat) -> CGFloat?
}


@IBDesignable
class GraphView: UIView {

    @IBInspectable
    var lineWidth: CGFloat = 1 { didSet{ setNeedsDisplay() } }
    @IBInspectable
    var scale: CGFloat = 50 { didSet{ setNeedsDisplay() } }
    var origin: CGPoint{
        return convertPoint(center, fromView: superview)
    }
    var discts: Bool = false //if a function is discontinuous, this var will be true and we won't draw a line to or from that point
    var color: UIColor = UIColor.blackColor(){ didSet{ setNeedsDisplay() } }
    //var contentScaleFactor: CGFloat = 1 // set this from UIView's contentScaleFactor to position axes with maximum accuracy
    
    weak var dataSource: GraphViewDataSource? // delegation
    
    override func drawRect(rect: CGRect) {
        AxesDrawer(contentScaleFactor: contentScaleFactor).drawAxesInRect(bounds, origin: origin, pointsPerUnit: scale)
        
        color.set()
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        var currPoint = CGPoint()
        for p in 0...Int(bounds.size.width * contentScaleFactor){ //p stands for pixel, for each pixel in the bound
            currPoint.x = CGFloat(p) / contentScaleFactor
            if let y = dataSource?.f(currPoint.x){
                if !y.isNormal && !y.isZero{
                    discts = true
                    continue //if function is discts at this point then do nothing and go to the next pixel (without moving)
                }
                currPoint.y = y
                if discts{
                    discts = false
                    path.moveToPoint(currPoint)
                }
                else{
                    path.addLineToPoint(currPoint)
                }
            }
            else{
                discts = true
            }
            path.stroke()
        }
    }
    

    
//    private struct Constants {
//        //static let HashmarkSize: CGFloat = 6
//    }
    
    
//    var graphRadius: CGFloat{
//        return min(bounds.size.width, bounds.size.height) / 2 * scale // so that bounds have some space with the screen
//    }
    
    
    //zoom
    func scale(gesture: UIPinchGestureRecognizer){
        if gesture.state == .Changed {
            scale *= gesture.scale
            gesture.scale = 1
        }
    }
    
    

}
