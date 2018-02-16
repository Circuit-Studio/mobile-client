//
//  UIComponent.swift
//  circuit-studio
//
//  Created by Erick Sanchez on 2/15/18.
//  Copyright © 2018 Circuit Studio. All rights reserved.
//

import UIKit

public class UIComponent: CSDraggable {
    
    init(size: CGSize) {
        super.init(size: size)
        self.image = UIImage(named: "no-component")!
        self.viewDidLoad()
        
    }
    
    override public init(size: CGSize, gridSize: CGSize?, snapWhileDragging dragging: Bool, delegate: CSDraggableDelegate?) {
        super.init(size: size, gridSize: gridSize, snapWhileDragging: dragging, delegate: delegate)
        self.image = UIImage(named: "no-component")!
    }
    
    override public init<Component>(from anotherDraggable: Component) where Component : UIComponent {
        super.init(from: anotherDraggable)
        self.image = anotherDraggable.image
        self.viewDidLoad()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.image = UIImage(named: "no-component")!
        self.viewDidLoad()
    }
    
    //TODO: display the data such as name, caption, nodes, size according to the grid size
    convenience init?(from component: CSComponent) {
        guard
            let image = component.image
            else {
                return nil
        }
        
        self.init(size: component.size)
        self.image = image
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        contentMode = .scaleAspectFit
        isUserInteractionEnabled = true
    }
}
