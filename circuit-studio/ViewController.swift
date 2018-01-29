//
//  ViewController.swift
//  circuit-studio
//
//  Created by Erick Sanchez on 1/18/18.
//  Copyright © 2018 Circuit Studio. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CSDraggableDelegate {
    
    private var dynamicAnimator: UIDynamicAnimator!
    
    private var gridCellSize: CGSize = CGSize(width: 32, height: 32)
    
    private var draggablesAndDynamicIems = [CSDraggable: UISnapBehavior]()
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    // MARK: CSDraggable Delegate
    
    func draggable(view: CSDraggable, didEndWith gesture: UIPanGestureRecognizer) {
        guard let snapBehavior = self.draggablesAndDynamicIems[view] else { return }
        
        let viewPosition = view.frame.origin
        let gridRemandierPosition: (x: Int, y: Int) = (
            Int(viewPosition.x / gridCellSize.width),
            Int(viewPosition.y / gridCellSize.height)
        )
        let snapPosition = CGPoint(
            x: CGFloat(gridRemandierPosition.x) * gridCellSize.width,
            y: CGFloat(gridRemandierPosition.y) * gridCellSize.height
        )
        snapBehavior.snapPoint = snapPosition
    }
    
    // MARK: - DRAW GRID
    
    func drawGrid(gridSize: Int) {
        let primaryGridSize = gridSize * 5
        let secondaryLineWidth: CGFloat = 1
        let primaryLineWidth: CGFloat = 2
        let lineColor: CGColor = UIColor.gray.cgColor
        
        // draw vertical lines
        for x in 0...Int(self.view.bounds.maxX) {
            if x % gridSize == 0 {
                let path = UIBezierPath()
                path.move(to: CGPoint(x: CGFloat(x), y: 0))
                path.addLine(to: CGPoint(x: CGFloat(x), y: self.view.bounds.maxY))
                
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = path.cgPath
                shapeLayer.strokeColor = lineColor
                shapeLayer.fillColor = UIColor.clear.cgColor
                
                if x % primaryGridSize == 0 {
                    shapeLayer.lineWidth = primaryLineWidth
                } else {
                    shapeLayer.lineWidth = secondaryLineWidth
                }
                
                self.view.layer.addSublayer(shapeLayer)
            }
        }
        
        // draw horizontal lines
        for y in 0...Int(self.view.bounds.maxY) {
            if y % gridSize == 0 {
                let path = UIBezierPath()
                path.move(to: CGPoint(x: 0, y: CGFloat(y)))
                path.addLine(to: CGPoint(x: self.view.bounds.maxX, y: CGFloat(y)))
                
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = path.cgPath
                shapeLayer.strokeColor = lineColor
                shapeLayer.fillColor = UIColor.clear.cgColor
                
                if y % primaryGridSize == 0 {
                    shapeLayer.lineWidth = primaryLineWidth
                } else {
                    shapeLayer.lineWidth = secondaryLineWidth
                }
                    
                self.view.layer.addSublayer(shapeLayer)
            }
        }
    }
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        self.drawGrid(gridSize: 25)
        // Do any additional setup after loading the view, typically from a nib.
        self.dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        for aView in self.view.subviews {
            guard let draggableView = aView as? CSDraggable else { return }
            draggableView.delegate = self
            let viewPosition = aView.frame.origin
            let gridRemandierPosition: (x: Int, y: Int) = (
                Int(viewPosition.x / gridCellSize.width),
                Int(viewPosition.y / gridCellSize.height)
            )
            let snapPosition = CGPoint(
                x: CGFloat(gridRemandierPosition.x) * gridCellSize.width,
                y: CGFloat(gridRemandierPosition.y) * gridCellSize.height
            )
            let behavior = UISnapBehavior(item: aView, snapTo: snapPosition)
            self.draggablesAndDynamicIems[draggableView] = behavior
            dynamicAnimator.addBehavior(behavior)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

