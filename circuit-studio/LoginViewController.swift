//
//  LoginViewController.swift
//  circuit-studio
//
//  Created by Duncan MacDonald on 2/15/18.
//  Copyright © 2018 Circuit Studio. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    
    let loginModel = LoginViewModel()
    
    weak var delegate: LoginViewControllerDelegate?
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        if emailTextField.text == "" || passwordTextField.text == "" {
            self.showAlert(title: "Error", message: "Please enter all fields", actionText: "Dismiss")
            return
        }
        if usernameTextField.text == "" && segmentControl.selectedSegmentIndex == 1 {
            self.showAlert(title: "Error", message: "Please enter all fields", actionText: "Dismiss")
            return
        }
        
        // handle login
        if segmentControl.selectedSegmentIndex == 0 {
            let user = UserHTTPBody(username: nil, email: emailTextField.text, password: passwordTextField.text)
            
            loginModel.login(a: user, callback: { (result) in
                switch result {
                case .success:
                    print("success")
                    self.dismiss(animated: true, completion: { [weak self] in
                        if let vc = self {
                            vc.delegate?.loginViewControllerDidLoginSuccessfully(vc)
                        }
                    })
                case .failure(let error):
                    self.showAlert(title: "Error", message: String(describing: error.errors), actionText: "Dismiss")
                }
            })
            
        // handle register
        } else if segmentControl.selectedSegmentIndex == 1 {
            let user = UserHTTPBody(username: usernameTextField.text, email: emailTextField.text, password: passwordTextField.text)
            
            loginModel.registerAndLogin(a: user, callback: { (result) in
                switch result {
                case .success:
                    self.dismiss(animated: true, completion: { [weak self] in
                        if let vc = self {
                            vc.delegate?.loginViewControllerDidLoginSuccessfully(vc)
                        }
                    })
                case .failure(let error):
                    self.showAlert(title: "Error", message: String(describing: error.errors), actionText: "Dismiss")
                }
            })
        }
    }
    
    @IBAction func segmentValueChanged(_ sender: Any) {
        print("changed")
        if segmentControl.selectedSegmentIndex == 0 {
            self.loginButton.setTitle("Login", for: .normal)
            self.usernameTextField.isHidden = true
            self.usernameLabel.isHidden = true
        } else if segmentControl.selectedSegmentIndex == 1 {
            self.loginButton.setTitle("Register", for: .normal)
            self.usernameTextField.isHidden = false
            self.usernameLabel.isHidden = false
        }
    }
    
}

protocol LoginViewControllerDelegate: class {
    func loginViewControllerDidLoginSuccessfully(_ viewController: LoginViewController)
}
