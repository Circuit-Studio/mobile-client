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
 
 - warning: CSDraggable must contain a self.superview
 */
public class CSDraggable: UIView, UIGestureRecognizerDelegate {
    
    private var panGesture: UIPanGestureRecognizer
    
    /**
     Starting point of the draggable's origin point
     
     - Warning: CGPoint is saved in the self.cartesianPlane's coordinates
     system
     */
    public private(set) var startingOrigin: CGPoint?
    
    /** Assign the cell size of snapping. Defaults to nil, thus drag without
     snapping
     */
    public lazy var snapGridSize: CGSize? = self.frame.size
    
    /**
     While dragging, snap according the to given snapGridSize
     
     - Precondition: snapGridSize must be set
     */
    public var snapWhileDragging: Bool = true
    
    @IBOutlet public weak var delegate: CSDraggableDelegate?
    
    @IBOutlet public lazy var cartesianPlane: UIView! = self.superview
    
    enum CSDraggableErrors: Error {
        case NoSuperview
        
        var localizedDescription: String {
            switch self {
            case .NoSuperview:
                return "CSDraggable must be contained in a superview"
            }
        }
    }
    
    /** last factored location
     
     // Grid size
     let gridSize = CGSize(width: 32, height: 32)
     factoredGridPosition = .. // for the point self.frame.origin (e.g. 70, 40)
     //factoredGridPosition = (x: 2, y: 1)
     
     */
    private var previousFactoredGridPosition: (x: Int, y: Int)?
    
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
    
    /**
     Copies the **size** and **frame.origin** from the *other draggable*. Use
     mappingToCartesianPlane if the otherDraggable.superview is different from
     its cartesianPlate
     
     - warning: the new instance is added to the cartesian plane, if given
     
     - parameter otherDraggable: the draggable to copy
     
     - parameter toCartesianView: the view to convert the draggable.origin to
     */
    public convenience init(delegate: CSDraggableDelegate? = nil, from otherDraggable: CSDraggable, mappingToCartesianPlane toCartesianView: UIView? = nil) {
        self.init(delegate: delegate)
        
        /* copy the size */
        self.frame.size = otherDraggable.frame.size
        
        /* copy the origin */
        toCartesianView?.addSubview(self)
        if let mappedOrigin = toCartesianView?.convert(otherDraggable.frame.origin, from: otherDraggable.superview) {
            self.frame.origin = mappedOrigin
        }
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
    
    /**
     <#Lorem ipsum dolor sit amet.#>
     - parameter OriginalPoint: the point of origin not the view's center point
     */
    public func returnToOriginPosition(animated: Bool, animation: ((_ OriginalPoint: CGPoint) -> ())? = nil) {
        guard let startingPoint = self.startingOrigin else {
            return print("previous point not set")
        }
        
        if let animationBlock = animation {
            let convertedPoint = self.convertPointFromCartesianPlane(point: startingPoint)
            
            animationBlock(convertedPoint)
        } else {
            if animated {
                let animator = UIViewPropertyAnimator()
                animator.addAnimations { [unowned self] in
                    self.frame.origin = self.convertPointFromCartesianPlane(point: startingPoint)
                }
                animator.startAnimation()
            } else {
                self.frame.origin = self.convertPointFromCartesianPlane(point: startingPoint)
            }
        }
    }
    
    /**
     Converts the point from the superview's cartesian plane to the
     self.cartesianPlane
     
     - throws: if self is not contained by a superview
     */
    private func convertPointToCartesianPlane(point: CGPoint) -> CGPoint {
        guard
            let containerView = self.cartesianPlane,
            let superview = self.superview else {
                preconditionFailure(CSDraggableErrors.NoSuperview.localizedDescription)
        }
        
        return containerView.convert(point, from: superview)
    }
    
    /**
     Converts the point from the cartesian plane to self.superview's cartesain
     plane
     
     - throws: if self is not contained by a superview
     */
    private func convertPointFromCartesianPlane(point: CGPoint) -> CGPoint {
        guard
            let containerView = self.cartesianPlane,
            let superview = self.superview else {
                preconditionFailure(CSDraggableErrors.NoSuperview.localizedDescription)
        }
        
        return superview.convert(point, from: containerView)
    }
    
    @objc private func panGesture(gesture: UIPanGestureRecognizer) {
        guard let mySuperview = cartesianPlane else { return }
        
        let transformation = gesture.translation(in: mySuperview)
        switch gesture.state {
        case .began:
            delegate?.draggable?(view: self, willBeginWith: gesture)
            
            startingOrigin = convertPointToCartesianPlane(point: self.frame.origin)
            
            delegate?.draggable?(view: self, didBeginWith: gesture)
        case .changed:
            delegate?.draggable?(view: self, willChangeWith: gesture)
            
            if snapWhileDragging {
                guard let startingPoint = startingOrigin else {
                    return print("Previous location not set")
                }
                guard let gridSize = self.snapGridSize else {
                    preconditionFailure("grid size is not set while snapWhileDraggin = true")
                }
                
                /** current point of the pan gesture's location */
                let panPosition = CGPoint(x: startingPoint.x + transformation.x, y: startingPoint.y + transformation.y)
                let currentFactoredGridPosition: (x: Int, y: Int) = (
                    Int(round(panPosition.x / gridSize.width)),
                    Int(round(panPosition.y / gridSize.height))
                )
                
                if let perviousGridPosition = previousFactoredGridPosition {
                    if perviousGridPosition != currentFactoredGridPosition {
                        /* snap to the new grid position */
                        //TODO: func snap(to point: CGPoint) {
                        let animator = UIViewPropertyAnimator()
                        animator.addAnimations { [unowned self] in
                            let snapPosition = CGPoint(
                                x: CGFloat(currentFactoredGridPosition.x) * gridSize.width,
                                y: CGFloat(currentFactoredGridPosition.y) * gridSize.height
                            )
                            self.frame.origin = self.convertPointFromCartesianPlane(point: snapPosition)
                        }
                        animator.startAnimation()
                        
                        // }
                    }
                }
                previousFactoredGridPosition = currentFactoredGridPosition
            } else {
                self.center = CGPoint(x: self.center.x + transformation.x, y: self.center.y + transformation.y)
                gesture.setTranslation(CGPoint.zero, in: mySuperview)
            }
            
            delegate?.draggable?(view: self, didChangeWith: gesture)
        case .ended:
            delegate?.draggable?(view: self, willEndWith: gesture)
            
            snapToGrid()
            
            delegate?.draggable?(view: self, didEndWith: gesture)
        default: break
        }
    }
    
    private func snapToGrid() {
        guard let gridSize = self.snapGridSize else {
            preconditionFailure("grid size is not set")
        }
        
        let animator = UIViewPropertyAnimator()
        animator.addAnimations { [unowned self] in
            let viewOrigin = self.convertPointToCartesianPlane(point: self.frame.origin)
            let gridPosition: (x: Int, y: Int) = (
                Int(round(viewOrigin.x / gridSize.width)),
                Int(round(viewOrigin.y / gridSize.height))
            )
            let snapPosition = CGPoint(
                x: CGFloat(gridPosition.x) * gridSize.width,
                y: CGFloat(gridPosition.y) * gridSize.height
            )
            self.frame.origin = self.convertPointFromCartesianPlane(point: snapPosition)
        }
        animator.startAnimation()
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
