//
//  UICanvas.swift
//  circuit-studio
//
//  Created by Erick Sanchez on 3/6/18.
//  Copyright © 2018 Circuit Studio. All rights reserved.
//

import UIKit

@objc protocol UICanvasDelegate: class {
    @objc optional func canvas(view: UICanvas, didTap gesture: UITapGestureRecognizer, at location: CGPoint)
    @objc optional func canvas(view: UICanvas, didPan gesture: UIPanGestureRecognizer, at location: CGPoint)
}

class UICanvas: UIGridView {
    
    private var tapGesture: UITapGestureRecognizer
    
    private var panGesture: UIPanGestureRecognizer
    
    @IBOutlet public weak var delegate: UICanvasDelegate?
    
    var items: [UIComponent] {
        return self.subviews.filter({ $0 is UIComponent }) as! [UIComponent]
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.tapGesture = UITapGestureRecognizer()
        self.panGesture = UIPanGestureRecognizer()
        super.init(coder: aDecoder)
        self.viewWillLoad()
        self.viewDidLoad()
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    var isCanvasEnabled = false
    public func enableItems(_ enabled: Bool) {
        isCanvasEnabled = enabled
        for anItem in self.items {
            anItem.isDraggableEnabled = enabled
        }
    }
    
    //TODO: override addSubview to update the self.items var
    
    @objc private func didTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        delegate?.canvas?(view: self, didTap: gesture, at: location)
    }
    
    @objc private func didPan(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self)
        delegate?.canvas?(view: self, didPan: gesture, at: location)
    }
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE
    
    private func viewWillLoad() {
        self.tapGesture.addTarget(self, action: #selector(UICanvas.didTap(_:)))
        self.addGestureRecognizer(tapGesture)
        self.panGesture.addTarget(self, action: #selector(UICanvas.didPan(_:)))
        self.addGestureRecognizer(panGesture)
    }
    
    public func viewDidLoad() { }
}
