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

class SplashScreenViewController: UIViewController, LoginViewControllerDelegate {
    
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
    
    // MARK: Login View Controller Delegate
    
    func loginViewControllerDidLoginSuccessfully(_ viewController: LoginViewController) {
        if let _ = PersistenceStack.userId {
            self.performSegue(withIdentifier: "show canvas", sender: self)
        }
    }
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE
}

