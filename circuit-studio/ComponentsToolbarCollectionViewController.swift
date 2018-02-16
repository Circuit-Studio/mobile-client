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
        CSComponent(name: "5v Battery", caption: "5v", size: CGSize(width: 1, height: 2), image: "battery"),
        CSComponent(name: "3v Battery", caption: "3v", size: CGSize(width: 1, height: 2), image: "battery"),
        CSComponent(name: "1v Battery", caption: "1v", size: CGSize(width: 1, height: 2), image: "battery")
    ] //FIXME: mock data
    
    weak var parentCanvasViewController: CanvasViewController!
    
    var nColumns: Int = 2
    
    // MARK: - RETURN VALUES
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return components.count * 5 //FIXME: mock data
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ComponentCollectionViewCell
        
        //FIXME: differenciate between a scroll and a pick up and drag
        //maybe by not dragging the actual cell in this collection view but
        //instead if dragging, vs scrolling, create a copy on the canvas view and
        //drag that object
//        cell.draggable.delegate = parentCanvasViewController
//        cell.draggable.cartesianPlane = parentCanvasViewController.view
//        cell.draggable.snapGridSize = parentCanvasViewController.gridSize
        cell.delegate = parentCanvasViewController
        
        return cell
    }
    
    // MARK: - VOID METHODS
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
