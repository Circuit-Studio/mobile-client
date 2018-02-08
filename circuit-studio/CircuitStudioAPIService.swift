//
//  CircuitStudioNeworkService.swift
//  circuit-studio
//
//  Created by Erick Sanchez on 2/6/18.
//  Copyright © 2018 Circuit Studio. All rights reserved.
//

import Foundation
import Moya
import Result

//TODO: Define MoyaProvider in a View Model in MVVM vs a struct
struct CircuitStudioNeworkService {
    
    let apiService = MoyaProvider<CSAPIEndpoints>()
    
    /**
     Fires a moya request using CSAPIEndpoints.Register and returns the result
     from MoyaProvider.request(..)
     
     - parameter user: decoable User containing .username, .email, and .password
     */
    func register(a user: RegisterUser, complition: @escaping (Result<Response, MoyaError>) -> ()) {
        apiService.request(.Register(user)) { (result) in
            complition(result)
        }
    }
}
