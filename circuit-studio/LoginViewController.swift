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
            self.showAlert(title: "Error", message: message!, actionText: "Dismiss")
        }
    }
    
    // MARK: - IBACTIONS
    
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
            loginModel.login()
            
//            let user = UserHTTPBody(username: nil, email: emailTextField.text, password: passwordTextField.text)
//
//            loginModel.login(a: user, callback: { (result) in
//                switch result {
//                case .success:
//                    print("success")
//                    self.dismiss(animated: true, completion: { [weak self] in
//                        if let vc = self {
//                            vc.delegate?.loginViewControllerDidLoginSuccessfully(vc)
//                        }
//                    })
//                case .failure(let error):
//                    self.showAlert(title: "Error", message: String(describing: error.errors), actionText: "Dismiss")
//                }
//            })
            
            // handle register
        } else if segmentControl.selectedSegmentIndex == 1 {
            loginModel.registerAndLogin()
            
//            let user = UserHTTPBody(username: usernameTextField.text, email: emailTextField.text, password: passwordTextField.text)
//
//            loginModel.registerAndLogin(a: user, callback: { (result) in
//                switch result {
//                case .success:
//                    self.dismiss(animated: true, completion: { [weak self] in
//                        if let vc = self {
//                            vc.delegate?.loginViewControllerDidLoginSuccessfully(vc)
//                        }
//                    })
//                case .failure(let error):
//                    self.showAlert(title: "Error", message: String(describing: error.errors), actionText: "Dismiss")
//                }
//            })
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
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        usernameTextField.rx.text.bind(to: loginModel.username).disposed(by: bag)
        emailTextField.rx.text.bind(to: loginModel.email).disposed(by: bag)
        passwordTextField.rx.text.bind(to: loginModel.password).disposed(by: bag)
    }
    
}
