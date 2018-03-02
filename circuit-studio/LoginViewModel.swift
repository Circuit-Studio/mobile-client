//
//  LoginViewModel.swift
//  circuit-studio
//
//  Created by Erick Sanchez on 2/12/18.
//  Copyright © 2018 Circuit Studio. All rights reserved.
//

import Foundation
import Moya
import Result
import SwiftyJSON
import RxSwift

protocol LoginViewModelDelegate: class {
    func login(viewModel: LoginViewModel, didCompleteLogin success: Bool, withError message: String?)
//    func login(viewModel: LoginViewModel, didCompleteRegister success: Bool, withError message: String?)
}

struct LoginViewModel {
    
    private(set) var username = Variable<String?>(nil)
    private(set) var email = Variable<String?>(nil)
    private(set) var password = Variable<String?>(nil)
    
    private let apiService = MoyaProvider<CSAPIEndpoints>()
    
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
        let user = UserHTTPBody(username: username.value, email: email.value, password: password.value)
        self.login(a: user, callback: { (result) in
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
        let user = UserHTTPBody(username: username.value, email: email.value, password: password.value)
        self.registerAndLogin(a: user, callback: { (result) in
            switch result {
            case .success:
                self.delegate.login(viewModel: self, didCompleteLogin: true, withError: nil)
            case .failure(let error):
                self.delegate.login(viewModel: self, didCompleteLogin: false, withError: error.localizedDescription)
            }
        })
    }

}

/**
 Moya extension
 */
private extension LoginViewModel {
    
    struct CSAPIUserError: Error {
        var errors = [String]()
        
        var localizedDescription: String {
            
            // combine the list of errors in sentences
            return self.errors.reduce("", { $0 + "\($1)\n"} )
        }
    }
    
    /**
     Register a user. Use `callback` to check if registering was successful or
     something went wrong. Then, check `Errors` from the associated type of
     failure (e.g. invalid username/email/password or already taken username/
     email).
     
     - parameter user: user to register using username, email, and password
     */
    func register(a user: UserHTTPBody, callback: @escaping (Result<String, CSAPIUserError>) -> ()) {
        /// handles the response data after the networkService has fired and come back with a result
        apiService.request(.Register(user)) { (result) in
            switch result {
            case .success(let response):
                guard
                    let responseJson = JSON(response.data).dictionary
                    else {
                        return assertionFailure("could not json(response.data)")
                }
                
                switch response.statusCode {
                    
                //Bad Request (missing fileds, invalid email/username/password
                case 400:
                    if let errorMessages = responseJson["message"]?.arrayObject as! [String]? {
                        var err = CSAPIUserError()
                        for aMessage in errorMessages {
                            err.errors.append(aMessage)
                        }
                        
                        callback(.failure(err))
                    } else if let errorMessage = responseJson["message"]?.string {
                        let err = CSAPIUserError(errors: [errorMessage])
                        
                        callback(.failure(err))
                    } else {
                        assertionFailure("could not json -> [String] nor json -> String")
                    }
                    
                //Forbidden - Already taken email/username
                case 403:
                    //FIXME: separate already taken emails and usernames into two different cases once the API returns each case
                    let err = CSAPIUserError(errors: ["A user already exists with that username or email address."])
                    
                    callback(.failure(err))
                    
                //Created
                case 201:
                    guard
                        let statusMessage = responseJson["message"]?.string
                        else {
                            return assertionFailure("could not json(response.data)")
                    }
                    
                    callback(.success(statusMessage))
                default:
                    assertionFailure("Unhandled response code")
                }
            case .failure(let err):
                callback(.failure(CSAPIUserError(errors: [err.localizedDescription])))
            }
        }
    }
    
    /** contains the token, username, and userId from a successful login */
    typealias SuccessfulLoginData = (token: String, userId: String, username: String)
    
    /**
     Explictly login a user and get back, if successful, a token and user id
     
     - parameter user: only needs to contain email and password
     */
    func login(a user: UserHTTPBody, callback: @escaping (Result<SuccessfulLoginData, CSAPIUserError>) -> ()) {
        apiService.request(.Login(user)) { (result) in
            switch result {
            case .success(let response):
                guard
                    let responseJson = JSON(response.data).dictionary
                    else {
                        return assertionFailure("could not json(response.data)")
                }
                
                switch response.statusCode {
                    
                //success
                case 200:
                    guard
                        let data = responseJson["data"],
                        let token = data["token"].string,
                        let username = data["username"].string,
                        let id = data["id"].string else {
                            return assertionFailure("could not parse data")
                    }
                    
                    let result: SuccessfulLoginData = (token, id, username)
                    
                    PersistenceStack.userToken = token
                    PersistenceStack.userId = id
                    
                    callback(.success(result))
                    
                //empty fields, User not found, wrong password, internal server error
                case 400, 401, 500:
                    guard let message = responseJson["message"]?.string else {
                        return assertionFailure("count not parse message")
                    }
                    
                    callback(.failure(CSAPIUserError(errors: [message])))
                default:
                    assertionFailure("unhandled status code")
                }
                
            case .failure(let errorMessage):
                callback(.failure(CSAPIUserError(errors: [errorMessage.localizedDescription])))
            }
        }
    }
    
    /**
     Use this if you'd like to combine regerstering a user and if successfull,
     log them in. This implicently calls login(a user, ..) in the success state of
     register(a user, ..)
     */
    func registerAndLogin(a user: UserHTTPBody, callback: @escaping (Result<SuccessfulLoginData, CSAPIUserError>) -> ()) {
        register(a: user, callback: { result in
            switch result {
            case .success:
                
                // now, login the user
                self.login(a: user, callback: { (result) in
                    switch result {
                    case .success(let data):
                        callback(.success(data))
                    case .failure(let error):
                        callback(.failure(error))
                    }
                })
            case .failure(let error):
                callback(.failure(error))
            }
        })
    }
}
