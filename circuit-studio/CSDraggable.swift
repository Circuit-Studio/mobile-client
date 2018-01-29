//
//  Draggable.swift
//  circuit-studio
//
//  Created by Erick Sanchez on 1/28/18.
//  Copyright © 2018 Circuit Studio. All rights reserved.
//

import UIKit

/**
 Basic delegation from the UIPanGestureRecognizer's target-action of begin,
 change, and end events.
 */
@objc public protocol CSDraggableDelegate {
    @objc optional func draggable(view: CSDraggable, willBeginWith gesture: UIPanGestureRecognizer)
    @objc optional func draggable(view: CSDraggable, didBeginWith gesture: UIPanGestureRecognizer)
    @objc optional func draggable(view: CSDraggable, willChangeWith gesture: UIPanGestureRecognizer)
    @objc optional func draggable(view: CSDraggable, didChangeWith gesture: UIPanGestureRecognizer)
    @objc optional func draggable(view: CSDraggable, willEndWith gesture: UIPanGestureRecognizer)
    @objc optional func draggable(view: CSDraggable, didEndWith gesture: UIPanGestureRecognizer)
}

/**
 'Abstract' class of a draggable view with a delegate property to recieve
 messages of begin, change, and end events.
 */
public class CSDraggable: UIView, UIGestureRecognizerDelegate {
    
    private var panGesture: UIPanGestureRecognizer
    
    @IBOutlet public weak var delegate: CSDraggableDelegate?
    
    // MARK: - RETURN VALUES
    
    public init(delegate: CSDraggableDelegate? = nil) {
        self.panGesture = UIPanGestureRecognizer()
        self.delegate = delegate
        
        super.init(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        self.panGesture.delegate = self
        self.panGesture.addTarget(self, action: #selector(CSDraggable.panGesture(gesture:)))
        self.addGestureRecognizer(panGesture)
        self.backgroundColor = .gray
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.panGesture = UIPanGestureRecognizer()
        self.delegate = nil
        
        super.init(coder: aDecoder)
        self.panGesture.delegate = self
        self.panGesture.addTarget(self, action: #selector(CSDraggable.panGesture(gesture:)))
        self.addGestureRecognizer(panGesture)
        self.backgroundColor = .gray
    }
    
    // MARK: - VOID METHODS
    
    @objc private func panGesture(gesture: UIPanGestureRecognizer) {
        guard let mySuperview = self.superview else { return }
        
        let transformation = gesture.translation(in: mySuperview)
        switch gesture.state {
        case .began:
            delegate?.draggable?(view: self, willBeginWith: gesture)
            //Do some code
            
            delegate?.draggable?(view: self, didBeginWith: gesture)
        case .changed:
            delegate?.draggable?(view: self, willChangeWith: gesture)
            
            self.center = CGPoint(x: self.center.x + transformation.x, y: self.center.y + transformation.y)
            gesture.setTranslation(CGPoint.zero, in: mySuperview)
            
            delegate?.draggable?(view: self, didChangeWith: gesture)
        case .ended:
            delegate?.draggable?(view: self, willEndWith: gesture)
            //Do some code
            
            delegate?.draggable?(view: self, didEndWith: gesture)
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
