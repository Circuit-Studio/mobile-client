//
//  Draggable.swift
//  circuit-studio
//
//  Created by Erick Sanchez on 1/28/18.
//  Copyright © 2018 Circuit Studio. All rights reserved.
//

import UIKit

class Draggable: UIView, UIGestureRecognizerDelegate {
    
    private(set) var panGesture: UIPanGestureRecognizer
    
    init() {
        self.panGesture = UIPanGestureRecognizer()
        
        super.init(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        self.panGesture.delegate = self
        self.panGesture.addTarget(self, action: #selector(Draggable.panGesture(gesture:)))
        self.addGestureRecognizer(panGesture)
        self.backgroundColor = .gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.panGesture = UIPanGestureRecognizer()
        
        super.init(coder: aDecoder)
        self.panGesture.delegate = self
        self.panGesture.addTarget(self, action: #selector(Draggable.panGesture(gesture:)))
        self.addGestureRecognizer(panGesture)
        self.backgroundColor = .gray
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    @objc private func panGesture(gesture: UIPanGestureRecognizer) {
        guard let mySuperview = self.superview else { return }
        let transformation = gesture.translation(in: mySuperview)
        switch gesture.state {
        case .began:
            break
        case .changed:
            self.center = CGPoint(x: self.center.x + transformation.x, y: self.center.y + transformation.y)
            gesture.setTranslation(CGPoint.zero, in: mySuperview)
            break
        case .ended:
            break
        default: break
        }
    }
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
