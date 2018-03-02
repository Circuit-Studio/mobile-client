//
//  CanvasViewController.swift
//  circuit-studio
//
//  Created by Erick Sanchez on 2/15/18.
//  Copyright © 2018 Circuit Studio. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController, CSDraggableDelegate, ComponentCollectionViewCellDeletate {
    
    @IBOutlet weak var labelDocTitle: UILabel!
    @IBOutlet weak var containerComponentToolbar: UIView!
    private weak var componentToolbarCollectionViewController: ComponentsToolbarCollectionViewController!
    
    private var viewModel = CanvasViewModel()
    
    var gridSize = CGSize(width: 64, height: 64)
    
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
                collectionViewController.parentCanvasViewController = self
            default: break
            }
        }
    }
    
    /**
     When a new component is dragged from the toolbar to the canvas
     */
    private var newDraggable: UIComponent?
    func componentCell(_ cell: ComponentCollectionViewCell, didLongPress gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            
            //TODO: use factories to create a UIComponent
            // create a new component from the cell that is being dragged from `cell.component`
            newDraggable = UIComponent(from: cell.component)
        case .changed:
            guard let draggable = newDraggable else { return }
            
            draggable.snap(to: gesture.location(in: draggable.cartesianPlane), alignedToGrid: true)
        case .ended:
            guard
                let draggable = newDraggable,
                let originalOrigin = draggable.startingOrigin
                else {
                    return
            }
            
            // delete the new copy if the user did not move it from its original
            //position
            if originalOrigin == draggable.frame.origin {
                draggable.removeFromSuperview()
            } else {
                
                //TODO: validate location of new location
                draggable.snap()
            }
            
            newDraggable = nil
        default:
            break
        }
    }
    
    // MARK: CSDraggable Delegate
    
    // MARK: - IBACTIONS
    
    @IBAction func pressRenameDoc(_ sender: Any) {
        
    }
    
    @IBAction func pressDocInfo(_ sender: Any) {
        
    }
    
    @IBOutlet weak var buttonProfile: UIButton!
    @IBAction func pressUserProfile(_ sender: Any) {
        if let _ = CSUser.currentUser() {
            //TODO: perform segue to a profile popover instead of logging out
            CSUser.logoutUser()
            
            buttonProfile.setTitle("Login", for: .normal)
        } else {
            self.performSegue(withIdentifier: "show login", sender: nil)
        }
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let username: String
        if let loggedInUser = CSUser.currentUser() {
            username = loggedInUser.username!
        } else {
            username = "Login"
        }
        
        buttonProfile.setTitle(username, for: .normal)
    }
}

