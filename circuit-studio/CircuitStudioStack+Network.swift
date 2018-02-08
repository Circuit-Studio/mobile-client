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
    
    struct CSAPIUserError: Error {
        var errors = [String]()
    }
    
    /**
     Register a user. Use `callback` to check if registering was successful or
     something went wrong. Then, check `Errors` from the associated type of
     failure (e.g. invalid username/email/password or already taken username/
     email).
     
     - parameter user: user to register using username, email, and password
     */
    func register(a user: RegisterUser, callback: @escaping (Result<String, CSAPIUserError>) -> ()) {
        /// handles the response data after the networkService has fired and come back with a result
        networkService.register(a: user) { (result) in
            switch result {
            case .success(let response):
                guard
                    let responseJson = JSON(response.data).dictionary
                    else {
                        return assertionFailure("could not json(response.data)")
                }
                
                switch response.statusCode {
                case 400: //Bad Request (missing fileds, invalid email/username/password
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
                case 403: //Forbidden - Already taken email/username
                    //FIXME: separate already taken emails and usernames into two different cases once the API returns each case
                    let err = CSAPIUserError(errors: ["A user already exists with that username or email address."])
                    
                    callback(.failure(err))
                case 201: //Created
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
                assertionFailure("request failed: \(err.localizedDescription)")
            }
        }
    }
}
