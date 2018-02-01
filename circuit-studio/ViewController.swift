//
//  ViewController.swift
//  circuit-studio
//
//  Created by Erick Sanchez on 1/18/18.
//  Copyright © 2018 Circuit Studio. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CSDraggableDelegate {
    
    @IBOutlet var toolbarComponents: [CSDraggable]!
    
    private var toolbarOriginalCenterPositionForComponent: CGPoint?
    
    private var gridSize: CGSize {
        let gridView = self.view as! GridView
        let size = CGFloat(gridView.minorGridSize)
        
        return CGSize(width: size, height: size)
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    // MARK: CSDraggable Delegate
    
    func draggable(view: CSDraggable, willBeginWith gesture: UIPanGestureRecognizer) {
        if toolbarComponents.contains(view) {
            toolbarOriginalCenterPositionForComponent = view.center
        }
    }
    
    func draggable(view: CSDraggable, didEndWith gesture: UIPanGestureRecognizer) {
        if toolbarComponents.contains(view) {
            //TODO:
            let isValidLocation = arc4random() % 2 == 0
            guard let originalCenterPoint = toolbarOriginalCenterPositionForComponent else {
                return print("Original point was not set for invalide drag location")
            }
            
            if isValidLocation {
                let _ = CSDraggable(delegate: self, from: view, mappingToCartesianPlane: self.view)
                
                /* animate the toolbar component back to origianl spot */
                let animateToOrigianlLocation = UIViewPropertyAnimator()
                view.alpha = 0.0
                animateToOrigianlLocation.addAnimations {
                    view.center = originalCenterPoint
                }
                animateToOrigianlLocation.addAnimations({
                    view.alpha = 1.0
                }, delayFactor: 1.0)
                animateToOrigianlLocation.startAnimation()
            } else {
                let animateToOrigianlLocation = UIViewPropertyAnimator()
                animateToOrigianlLocation.addAnimations {
                    view.center = originalCenterPoint
                }
                animateToOrigianlLocation.startAnimation()
            }
        }
    }
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

}

