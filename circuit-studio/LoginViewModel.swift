//
//  LoginViewModel.swift
//  circuit-studio
//
//  Created by Erick Sanchez on 2/12/18.
//  Copyright © 2018 Circuit Studio. All rights reserved.
//

import Foundation
import RxSwift

protocol LoginViewModelDelegate: class {
    func login(viewModel: LoginViewModel, didCompleteLogin success: Bool, withError message: String?)
//    func login(viewModel: LoginViewModel, didCompleteRegister success: Bool, withError message: String?)
}

struct LoginViewModel {
    
    private(set) var username = Variable<String?>(nil)
    private(set) var email = Variable<String?>(nil)
    private(set) var password = Variable<String?>(nil)
    
    private var networkModel = NetworkStack()
    
    unowned var delegate: LoginViewModelDelegate
    
    init(delegate: LoginViewModelDelegate) {
        self.delegate = delegate
    }
    
    /**
     Checks if the fields, either username and email and password or only email
     and password, have met the requirements (length and valid email)
     
     - parameter forLogin: check which fields to validate
     
     - parameter invalidHandler: this is invoked when validation has failed
     */
    func validateInputFields(forLogin: Bool, invalidHandler: () -> ()) {
        guard
            let email = email.value,
            let password = password.value
            else {
                return invalidHandler()
        }
        
        //validate email and password only, user is logging in
        if forLogin {
            if email == "" || password == "" {
                invalidHandler()
            }
            
        //validate all fields, user is registering
        } else {
            guard let username = username.value else {
                return invalidHandler()
            }
            
            if email == "" || password == "" || username == "" {
                invalidHandler()
            }
        }
    }
    
    /**
     invokes the login network call and stores the successful response onto disk
     
     - precondition: username, email and password must be validated using validateInputFields(..)
     */
    func login() {
        guard
            let email = email.value,
            let password = password.value else {
                fatalError("login was invoked without validation")
        }
        
        let user = CSUser(username: username.value, email: email, password: password)
        networkModel.login(a: user, callback: { (result) in
            switch result {
            case .success:
                self.delegate.login(viewModel: self, didCompleteLogin: true, withError: nil)
            case .failure(let error):
                self.delegate.login(viewModel: self, didCompleteLogin: false, withError: error.localizedDescription)
            }
        })
    }
    
    /**
     invokes the registerAdnLogin network call and stores the successful
     response from the login
     
     - precondition: username, email and password must be validated using validateInputFields(..)
     */
    func registerAndLogin() {
        guard
            let email = email.value,
            let password = password.value else {
                fatalError("login was invoked without validation")
        }
        
        let user = CSUser(username: username.value, email: email, password: password)
        networkModel.registerAndLogin(a: user, callback: { (result) in
            switch result {
            case .success:
                self.delegate.login(viewModel: self, didCompleteLogin: true, withError: nil)
            case .failure(let error):
                self.delegate.login(viewModel: self, didCompleteLogin: false, withError: error.localizedDescription)
            }
        })
    }

}
