//
//  CircuitStudioStack+Network.swift
//  circuit-studio
//
//  Created by Erick Sanchez on 2/6/18.
//  Copyright © 2018 Circuit Studio. All rights reserved.
//

import Foundation
import SwiftyJSON
import Result

extension CircuitStudioStack {
    struct RegisterUserError: Error {
        
        enum Errors: Error {
            case InvalidEmail
            case InvalidUsername
            case InvalidPassword
            case UsernameOrEmailAlreadyTaken
            
            init?(_ aMessage: String) {
                switch aMessage {
                case "Username is too short.":
                    self = .InvalidUsername
                case "Password is too short.":
                    self = .InvalidPassword
                case "Not a valid email address.":
                    self = .InvalidEmail
                default:
                    return nil
                }
            }
        }
        var errors: [RegisterUserError.Errors] = []
        
        var localizedDescription: String {
            return String(describing: errors)
        }
    }
    
    /**
     <#Lorem ipsum dolor sit amet.#>
     
     - parameter <#bar#>: <#Consectetur adipisicing elit.#>
     
     - returns: <#Sed do eiusmod tempor.#>
     */
    func register(a user: RegisterUser, callback: @escaping (Result<String, RegisterUserError>) -> ()) {
        /// handles the response data after the networkService has fired and come back with a result
        networkService.register(a: user) { (result) in
            switch result {
            case .success(let response):
                guard
                    let responseJson = JSON(response.data).dictionary,
                    let statusMessage = responseJson["message"]?.string
                    else {
                        return assertionFailure("could not json(response.data)")
                }
                
                switch response.statusCode {
                case 201: //Created
                    callback(.success(statusMessage))
                case 403: //Forbidden - Already taken
                    let err = RegisterUserError(errors: [.UsernameOrEmailAlreadyTaken])
                    
                    callback(.failure(err))
                case 400: //Bad Request
                    guard let errorMessages = responseJson["message"]?.arrayObject as! [String]? else {
                        return assertionFailure("could not json -> [String]")
                    }
                    
                    var err = RegisterUserError()
                    for aMessage in errorMessages {
                        if let error = RegisterUserError.Errors(aMessage) {
                            err.errors.append(error)
                        } else {
                            assertionFailure("Unhandled error message")
                        }
                    }
                    
                    callback(.failure(err))
                default:
                    assertionFailure("Unhandled response code")
                }
            case .failure(let err):
                assertionFailure("request failed: \(err.localizedDescription)")
            }
        }
    }
}
