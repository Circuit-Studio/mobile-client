//
//  LoginViewController.swift
//  circuit-studio
//
//  Created by Duncan MacDonald on 2/15/18.
//  Copyright © 2018 Circuit Studio. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol LoginViewControllerDelegate: class {
    func loginViewControllerDidLoginSuccessfully(_ viewController: LoginViewController)
}

class LoginViewController: UIViewController, LoginViewModelDelegate {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    
    lazy var loginModel = LoginViewModel(delegate: self)
    
    private let bag = DisposeBag()
    
    weak var delegate: LoginViewControllerDelegate?
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    // MARK: View Model Delegate
    
    func login(viewModel: LoginViewModel, didCompleteLogin success: Bool, withError message: String?) {
        if success {
            self.dismiss(animated: true, completion: { [weak self] in
                if let vc = self {
                    vc.delegate?.loginViewControllerDidLoginSuccessfully(vc)
                }
            })
        } else {
            self.showAlert(title: "Logging In", message: message!, actionText: "Dismiss")
        }
    }
    
    // MARK: - IBACTIONS
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let userLoggingIn = segmentControl.selectedSegmentIndex == 0
        
        loginModel.validateInputFields(forLogin: userLoggingIn) {
            self.showAlert(title: "Error", message: "Please enter all fields", actionText: "Dismiss")
            
            return
        }
        
        if userLoggingIn {
            loginModel.login()
        } else {
            loginModel.registerAndLogin()
        }
    }
    
    @IBAction func segmentValueChanged(_ sender: Any) {
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
    
    @IBAction func pressDismiss(sender: AnyObject) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        usernameTextField.rx.text.bind(to: loginModel.username).disposed(by: bag)
        emailTextField.rx.text.bind(to: loginModel.email).disposed(by: bag)
        passwordTextField.rx.text.bind(to: loginModel.password).disposed(by: bag)
    }
    
}
