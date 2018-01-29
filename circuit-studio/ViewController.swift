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
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
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

