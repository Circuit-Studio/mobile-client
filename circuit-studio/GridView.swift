//
//  GridView.swift
//  circuit-studio
//
//  Created by Duncan MacDonald on 1/30/18.
//  Copyright © 2018 Circuit Studio. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GridView: UIView {
    
    @IBInspectable
    public var minorGridSize: Int = 32
    
    @IBInspectable
    public var majorGridMultiplier: Int = 5
    
    override func draw(_ rect: CGRect) {
        let majorGridSize = minorGridSize * majorGridMultiplier
        let minorLineWidth: CGFloat = 1
        let majorLineWidth: CGFloat = 2
        let lineColor: CGColor = UIColor.gray.cgColor
        
        // draw vertical lines
        for x in 0...Int(self.bounds.maxX) {
            if x % minorGridSize == 0 {
                let path = UIBezierPath()
                path.move(to: CGPoint(x: CGFloat(x), y: 0))
                path.addLine(to: CGPoint(x: CGFloat(x), y: self.bounds.maxY))
                
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = path.cgPath
                shapeLayer.strokeColor = lineColor
                shapeLayer.fillColor = UIColor.clear.cgColor
                
                if x % majorGridSize == 0 {
                    shapeLayer.lineWidth = majorLineWidth
                } else {
                    shapeLayer.lineWidth = minorLineWidth
                }
                
                self.layer.addSublayer(shapeLayer)
            }
        }
        
        // draw horizontal lines
        for y in 0...Int(self.bounds.maxY) {
            if y % minorGridSize == 0 {
                let path = UIBezierPath()
                path.move(to: CGPoint(x: 0, y: CGFloat(y)))
                path.addLine(to: CGPoint(x: self.bounds.maxX, y: CGFloat(y)))
                
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = path.cgPath
                shapeLayer.strokeColor = lineColor
                shapeLayer.fillColor = UIColor.clear.cgColor
                
                if y % majorGridSize == 0 {
                    shapeLayer.lineWidth = majorLineWidth
                } else {
                    shapeLayer.lineWidth = minorLineWidth
                }
                
                self.layer.addSublayer(shapeLayer)
            }
        }
    }
}
