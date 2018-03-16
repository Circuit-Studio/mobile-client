//
//  CanvasViewController.swift
//  circuit-studio
//
//  Created by Erick Sanchez on 2/15/18.
//  Copyright © 2018 Circuit Studio. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController, CSDraggableDelegate, UICanvasDelegate, ComponentCollectionViewCellDeletate {
    
    @IBOutlet weak var labelDocTitle: UILabel!
    @IBOutlet weak var containerComponentToolbar: UIView!
    private weak var componentToolbarCollectionViewController: ComponentsToolbarCollectionViewController!
    
    private enum Toolbar {
        case None
        case WireTool
        case CursorTool
        case TextBoxTool
        case ShapeTool
    }
    private var selectedTool = Toolbar.None
    
    private var viewModel = CanvasViewModel()
    
    var canvas: UICanvas {
        return self.view as! UICanvas
    }
    
    var gridSize = CGSize(width: 64, height: 64)
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    private func select(_ tool: Toolbar) {
        
        // deselect the same tool that was selected
        if self.selectedTool == tool {
            self.selectedTool = .None
        } else {
            self.selectedTool = tool
        }
        
        if self.selectedTool == .CursorTool {
            self.canvas.enableItems(true)
        } else {
            self.canvas.enableItems(false)
        }
        
        let selectColor = UIColor.blue
        let deselectColor = UIColor.clear
        switch self.selectedTool {
        case .None:
            buttonWireTool.backgroundColor = deselectColor
            buttonSelectTool.backgroundColor = deselectColor
            buttonTextTool.backgroundColor = deselectColor
            buttonShapeTool.backgroundColor = deselectColor
        case .WireTool:
            buttonWireTool.backgroundColor = selectColor
            buttonSelectTool.backgroundColor = deselectColor
            buttonTextTool.backgroundColor = deselectColor
            buttonShapeTool.backgroundColor = deselectColor
        case .CursorTool:
            buttonWireTool.backgroundColor = deselectColor
            buttonSelectTool.backgroundColor = selectColor
            buttonTextTool.backgroundColor = deselectColor
            buttonShapeTool.backgroundColor = deselectColor
        case .TextBoxTool:
            buttonWireTool.backgroundColor = deselectColor
            buttonSelectTool.backgroundColor = deselectColor
            buttonTextTool.backgroundColor = selectColor
            buttonShapeTool.backgroundColor = deselectColor
        case .ShapeTool:
            buttonWireTool.backgroundColor = deselectColor
            buttonSelectTool.backgroundColor = deselectColor
            buttonTextTool.backgroundColor = deselectColor
            buttonShapeTool.backgroundColor = selectColor
        }
    }
    
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
            newDraggable?.isDraggableEnabled = self.canvas.isCanvasEnabled
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
    
    // MARK: UICanvas Delegate
    
    private var tapLocation: CGPoint?
    func canvas(view: UICanvas, didTap gesture: UITapGestureRecognizer, at location: CGPoint) {
        if self.selectedTool == .TextBoxTool {
            tapLocation = location
            let alert = UIAlertController(title: "Textbox Tool", message: "enter the text", preferredStyle: .alert)
            alert.addTextField(defaultText: nil, placeholderText: "textbox text")
                .addButton(title: "Cancel")
                .addButton(title: "Add", with: { [weak self] (action) in
                    guard
                        let unweakSelf = self,
                        let point = unweakSelf.tapLocation,
                        let text = alert.inputField.text
                        else {
                            return
                    }
                    
                    //TODO: use a factory
                    let label = UILabel(frame: CGRect(origin: point, size: CGSize.zero))
                    label.text = text
                    label.sizeToFit()
                    unweakSelf.canvas.addSubview(label)
                })
                .present(in: self)
        }
    }
    
    // MARK: CSDraggable Delegate
    
//    func draggable(view: CSDraggable, willBeginWith gesture: UIPanGestureRecognizer) {
//        if selectedTool != .CursorTool {
////            gesture.
//        }
//    }
    
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
    
    @IBOutlet weak var buttonWireTool: UIButton!
    @IBAction func pressWireTool(_ sender: Any) {
        self.select(.WireTool)
    }
    
    @IBOutlet weak var buttonSelectTool: UIButton!
    @IBAction func pressSelectTool(_ sender: Any) {
        self.select(.CursorTool)
    }
    
    @IBOutlet weak var buttonTextTool: UIButton!
    @IBAction func pressTextboxTool(_ sender: Any) {
        self.select(.TextBoxTool)
    }
    
    @IBOutlet weak var buttonShapeTool: UIButton!
    @IBAction func pressShapeTool(_ sender: Any) {
        self.select(.ShapeTool)
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

