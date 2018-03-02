//
//  ComponentsToolbarCollectionViewController.swift
//  circuit-studio
//
//  Created by Erick Sanchez on 2/15/18.
//  Copyright © 2018 Circuit Studio. All rights reserved.
//

import UIKit

class ComponentsToolbarCollectionViewController: UICollectionViewController {
    
    var components: [CSComponent] = [
        CSComponent(name: "Resistor", caption: "5 Umms", size: CGSize(width: 1, height: 1), image: "resistor"),
        CSComponent(name: "Capacitor", caption: "5v", size: CGSize(width: 1, height: 2), image: "capacitor"),
        CSComponent(name: "Diode", caption: "3v", size: CGSize(width: 1, height: 2), image: "diode"),
        CSComponent(name: "Switch", caption: "1v", size: CGSize(width: 1, height: 2), image: "switch"),
        CSComponent(name: "Transistor", caption: "1v", size: CGSize(width: 1, height: 2), image: "transistor")
    ] //FIXME: mock data
    
    weak var parentCanvasViewController: CanvasViewController!
    
    var nColumns: Int = 2
    
    // MARK: - RETURN VALUES
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return components.count * 5 //FIXME: mock data
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ComponentCollectionViewCell
        
        //TODO: use factories
        // Create a component to copy from when a user drags from the collection
        //to the canvas
        let component = components[indexPath.row % 5] //FIXME: mock data
        cell.component.image = component.image
        cell.component.delegate = parentCanvasViewController
        cell.component.cartesianPlane = parentCanvasViewController.view
        cell.component.snapGridSize = parentCanvasViewController.gridSize
        cell.component.snapWhileDragging = true
        cell.component.isEnabled = false
        cell.delegate = parentCanvasViewController
        
        return cell
    }
    
    // MARK: - VOID METHODS
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register the cell
        let cellNib = UINib(nibName: "ComponentCollectionViewCell", bundle: Bundle.main)
        self.collectionView!.register(cellNib, forCellWithReuseIdentifier: "cell")
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
