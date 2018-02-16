//
//  UIComponent.swift
//  circuit-studio
//
//  Created by Erick Sanchez on 2/15/18.
//  Copyright © 2018 Circuit Studio. All rights reserved.
//

import UIKit

public class UIComponent: CSDraggable {
    
    public var image = UIImage(named: "no-component")!
    
    init() {
        super.init()
    }
    
    public override init(delegate: CSDraggableDelegate?, gridSize: CGSize?, snapWhileDragging dragging: Bool) {
        super.init(delegate: delegate, gridSize: gridSize, snapWhileDragging: dragging)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //TODO: clean up init
    public convenience init(fromAnother draggable: UIComponent) {
        self.init()
        
        self.snapGridSize = draggable.snapGridSize
        self.snapWhileDragging = draggable.snapWhileDragging
        self.cartesianPlane = draggable.cartesianPlane
        self.delegate = draggable.delegate
//        self.startingOrigin = draggable.startingOrigin
        
        self.image = draggable.image
        
        /* copy the size */
        self.frame.size = draggable.frame.size
        
        /* copy the origin */
        self.cartesianPlane.addSubview(self)
        self.frame.origin = self.cartesianPlane.convert(draggable.frame.origin, from: draggable.superview)
        //        self.startingOrigin = self.frame.origin
    }
    
    init?(from component: CSComponent) {
        guard
            let image = component.image
            else {
                return nil
        }
        
        super.init()
        
        self.image = image
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundColor = UIColor(patternImage: image)
    }

}
