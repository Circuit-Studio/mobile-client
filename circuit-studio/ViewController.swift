//
//  ViewController.swift
//  circuit-studio
//
//  Created by Erick Sanchez on 1/18/18.
//  Copyright © 2018 Circuit Studio. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON

class ViewController: UIViewController, CSDraggableDelegate {
    
    @IBOutlet var toolbarComponents: [CSDraggable]!
    
    private var gridSize: CGSize {
        let gridView = self.view as! GridView
        let size = CGFloat(gridView.minorGridSize)
        
        return CGSize(width: size, height: size)
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    // MARK: CSDraggable Delegate
    
    func draggable(view: CSDraggable, didEndWith gesture: UIPanGestureRecognizer) {
        if toolbarComponents.contains(view) {
            //TODO:
            let isValidLocation = arc4random() % 2 == 0
            
            if isValidLocation {
                let _ = CSDraggable(delegate: self, from: view, mappingToCartesianPlane: self.view)
                
                /* animate the toolbar component back to origianl spot */
                view.returnToOriginPosition(animated: true, animation: { (originPoint) in
                    view.alpha = 0.0
                    view.frame.origin = originPoint
                    UIView.animate(withDuration: 0.5, animations: {
                        view.alpha = 1.0
                    })
                })
            } else {
                view.returnToOriginPosition(animated: true)
            }
        }
    }
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let user = RegisterUser(username: "essssss", email: "e@c.com", password: "passssss")
        CircuitStudioStack.shared.register(a: user) { (result) in
            switch result {
            case .success(let message):
                print(message)
                //TODO: login the new user
            case .failure(let registerError):
                for aError in registerError.errors {
                    switch aError {
                    case .InvalidEmail:
                        print("invalid email, yo!")
                    case .InvalidUsername:
                        print("invalid username, dude! or gal")
                    case .InvalidPassword:
                        print("invalid password")
                    case .UsernameOrEmailAlreadyTaken:
                        print("username or email already taken, think better!")
                    }
                }
            }
        }
    }
}

