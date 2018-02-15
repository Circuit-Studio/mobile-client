//
//  CanvasViewController.swift
//  circuit-studio
//
//  Created by Erick Sanchez on 2/15/18.
//  Copyright © 2018 Circuit Studio. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {
    
    @IBOutlet weak var labelDocTitle: UILabel!
    @IBOutlet weak var containerComponentToolbar: UIView!
    private var componentToolbarCollectionViewController: ComponentsToolbarCollectionViewController!
    
    private var viewModel = CanvasViewModel()
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "embeded collection controller":
                guard let collectionViewController = segue.destination as? ComponentsToolbarCollectionViewController else {
                    fatalError("ComponentsToolbarCollectionViewController is not set in the storyboard")
                }
                
                componentToolbarCollectionViewController = collectionViewController
            default: break
            }
        }
    }
    
    // MARK: - IBACTIONS
    
    @IBAction func pressRenameDoc(_ sender: Any) {
        
    }
    @IBAction func pressDocInfo(_ sender: Any) {
        
    }
    @IBOutlet weak var buttonProfile: UIButton!
    @IBAction func pressUserProfile(_ sender: Any) {
        
    }
    @IBOutlet weak var segComponentsTab: UISegmentedControl!
    @IBAction func segComponentsTabDidChange(_ sender: Any) {
        
    }
    @IBAction func pressWireTool(_ sender: Any) {
        
    }
    @IBAction func pressSelectTool(_ sender: Any) {
        
    }
    @IBAction func pressTextboxTool(_ sender: Any) {
        
    }
    @IBAction func pressShapeTool(_ sender: Any) {
        
    }
    // MARK: - LIFE CYCLE

}
