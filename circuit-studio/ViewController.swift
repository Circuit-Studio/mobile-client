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

class ViewController: UIViewController, CSDraggableDelegate, LoginViewControllerDelegate {
    
    func loginViewControllerDidLoginSuccessfully(_ viewController: LoginViewController) {
        if let _ = PersistenceStack.loggedInUserId {
            print("logged in")
            self.performSegue(withIdentifier: "show canvas", sender: self)
        }
    }
    
    
    let viewModel = LoginViewModel()
    
    @IBOutlet var toolbarComponents: [CSDraggable]!
    
    private var gridSize: CGSize {
        let gridView = self.view as! GridView
        let size = CGFloat(gridView.minorGridSize)
        
        return CGSize(width: size, height: size)
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "show login":
                let loginVC = segue.destination as! LoginViewController
                loginVC.delegate = self
            default:
                break
            }
        }
    }
    
    // MARK: CSDraggable Delegate
    
    func draggable(view: CSDraggable, didEndWith gesture: UIPanGestureRecognizer) {
        if toolbarComponents.contains(view) {
            //TODO: check for valid location when dragging a new component
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
        viewModel.registerAndLogin(a: UserHTTPBody(username: "erickes4", email: "e@d.net", password: "longehough")) { (result) in
            switch result {
            case .success(let loginData):
                print(loginData)
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

