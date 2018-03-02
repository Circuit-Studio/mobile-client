//
//  ComponentCollectionViewCell.swift
//  circuit-studio
//
//  Created by Erick Sanchez on 2/15/18.
//  Copyright © 2018 Circuit Studio. All rights reserved.
//

import UIKit

@objc protocol ComponentCollectionViewCellDeletate {
    @objc optional func componentCell(_ cell: ComponentCollectionViewCell, didLongPress gesture: UILongPressGestureRecognizer)
}

class ComponentCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: ComponentCollectionViewCellDeletate?
    
    @IBOutlet weak var component: UIComponent!
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    // MARK: - IBACTIONS
    
    @objc func didLongPress(_ sender: Any) {
        delegate?.componentCell?(self, didLongPress: sender as! UILongPressGestureRecognizer)
    }
    
    // MARK: - LIFE CYCLE
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(ComponentCollectionViewCell.didLongPress(_:)))
        self.addGestureRecognizer(gesture)
    }

}
