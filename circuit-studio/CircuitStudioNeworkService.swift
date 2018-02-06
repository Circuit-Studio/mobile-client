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

struct CircuitStudioNeworkService {
    
    let apiService = MoyaProvider<CSAPIEndpoints>()
    
    /**
     <#Lorem ipsum dolor sit amet.#>
     
     - parameter <#bar#>: <#Consectetur adipisicing elit.#>
     
     - returns: <#Sed do eiusmod tempor.#>
     */
    func register(a user: RegisterUser, complition: @escaping (Result<Response, MoyaError>) -> ()) {
        apiService.request(.Register(user)) { (result) in
            complition(result)
        }
    }
}
