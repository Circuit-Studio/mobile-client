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
public class CSDraggable: UIImageView, UIGestureRecognizerDelegate {
    
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
    public var snapGridSize: CGSize?
    
    /**
     While dragging, snap according the to given snapGridSize
     
     - Precondition: snapGridSize must be set
     */
    public var snapWhileDragging: Bool
    
    @IBOutlet public weak var delegate: CSDraggableDelegate?
    
    @IBOutlet public lazy var cartesianPlane: UIView! = self.superview
    
    public var isEnabled: Bool {
        get {
            return isUserInteractionEnabled
        }
        set {
            isUserInteractionEnabled = newValue
        }
    }
    
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
    
    public init(size: CGSize, gridSize: CGSize? = nil, snapWhileDragging dragging: Bool = false, delegate: CSDraggableDelegate? = nil) {
        self.panGesture = UIPanGestureRecognizer()
        self.delegate = delegate
        self.snapGridSize = gridSize
        self.snapWhileDragging = dragging
        super.init(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.viewWillLoad()
        self.viewDidLoad()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.panGesture = UIPanGestureRecognizer()
        self.delegate = nil
        self.snapGridSize = nil
        self.snapWhileDragging = false
        super.init(coder: aDecoder)
        self.viewWillLoad()
        self.viewDidLoad()
    }
    
    public init<Draggable>(from anotherDraggable: Draggable) where Draggable : CSDraggable {
        self.panGesture = UIPanGestureRecognizer()
        self.delegate = anotherDraggable.delegate
        self.snapGridSize = anotherDraggable.snapGridSize
        self.snapWhileDragging = anotherDraggable.snapWhileDragging

        self.snapGridSize = anotherDraggable.snapGridSize
        self.snapWhileDragging = anotherDraggable.snapWhileDragging
        self.delegate = anotherDraggable.delegate
        self.startingOrigin = anotherDraggable.startingOrigin
        
        super.init(frame: anotherDraggable.frame)
        self.viewWillLoad()

        self.cartesianPlane = anotherDraggable.cartesianPlane
        self.cartesianPlane.addSubview(self)
        if anotherDraggable.cartesianPlane != anotherDraggable.superview {
            self.frame.origin = self.cartesianPlane.convert(anotherDraggable.frame.origin, from: anotherDraggable.superview)
        } else {
            self.frame.origin = anotherDraggable.frame.origin
        }
        self.startingOrigin = self.frame.origin
        self.viewDidLoad()
    }
    
    private func viewWillLoad() {
        self.panGesture.delegate = self
        self.panGesture.addTarget(self, action: #selector(CSDraggable.panGesture(gesture:)))
        self.addGestureRecognizer(panGesture)
    }
    
    public func viewDidLoad() { }
    
    // MARK: - VOID METHODS
    
    /**
     <#Lorem ipsum dolor sit amet.#>
     - parameter OriginalPoint: the point of origin not the view's center point
     */
    public func returnToOriginPosition(animated: Bool, animation: ((_ OriginalPoint: CGPoint) -> ())? = nil, complition: ((UIViewAnimatingPosition) -> ())? = nil) {
        guard let startingPoint = self.startingOrigin else {
            return print("previous point not set")
        }
        
        let convertedPoint = convertPointFromCartesianPlane(point: startingPoint)
        if let animationBlock = animation {
            animationBlock(convertedPoint)
        } else {
            if animated {
                let animator = UIViewPropertyAnimator()
                animator.addAnimations {
                    self.frame.origin = convertedPoint
                }
                animator.startAnimation()
                if let handler = complition {
                    animator.addCompletion(handler)
                }
            } else {
                self.frame.origin = convertedPoint
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
        guard let mySuperview = cartesianPlane, self.isEnabled == true else { return }
        
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
                        /* snap to the new position according to the grid size */
                        let snapPosition = CGPoint(
                            x: CGFloat(currentFactoredGridPosition.x) * gridSize.width,
                            y: CGFloat(currentFactoredGridPosition.y) * gridSize.height
                        )
                        snap(to: snapPosition, alignedToGrid: false)
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
            
            if self.snapGridSize != nil {
                snap(to: self.frame.origin, alignedToGrid: snapGridSize != nil)
            }
            
            delegate?.draggable?(view: self, didEndWith: gesture)
        default: break
        }
    }
    
    func snap(to point: CGPoint, alignedToGrid snapping: Bool) {
        
        let animator = UIViewPropertyAnimator()
        animator.addAnimations { [unowned self] in
            if snapping {
                guard let gridSize = self.snapGridSize else {
                    preconditionFailure("grid size is not set")
                }
                
                let origin = self.convertPointToCartesianPlane(point: point)
                let gridPosition: (x: Int, y: Int) = (
                    Int(round(origin.x / gridSize.width)),
                    Int(round(origin.y / gridSize.height))
                )
                let snapPosition = CGPoint(
                    x: CGFloat(gridPosition.x) * gridSize.width,
                    y: CGFloat(gridPosition.y) * gridSize.height
                )
                self.frame.origin = self.convertPointFromCartesianPlane(point: snapPosition)
            } else {
                self.frame.origin = self.convertPointFromCartesianPlane(point: point)
            }
        }
        animator.startAnimation()
    }
    
    func snap(to cartesianPlane: UIView? = nil) {
        let point = cartesianPlane?.convert(self.frame.origin, from: self.cartesianPlane) ?? self.frame.origin
        self.snap(to: point, alignedToGrid: snapGridSize != nil)
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
