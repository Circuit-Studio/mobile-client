//
//  RegisterService.swift
//  circuit-studio
//
//  Created by Erick Sanchez on 2/5/18.
//  Copyright © 2018 Circuit Studio. All rights reserved.
//

import Foundation
import Moya

//TODO: preprocessor for degub build or production to determin baseUrl
public var apiBaseUrl = "http://staging-api.circuit.studio"

public enum RegisterAPI {
    case Register(username: String, password: String, email: String)
}

//TODO: use moya generated code
extension RegisterAPI: TargetType {
    public var baseURL: URL {
        return URL(string: apiBaseUrl)!
    }
    
    public var path: String {
        switch self {
        case .Register:
            return "/auth/register"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .Register:
            return .post
        }
    }
    
    public var sampleData: Data {
        return "Not implemented".data(using: .utf8)!
    }
    
    public var task: Task {
        switch self {
        case .Register(let username, let password, let email):
             return .requestParameters(parameters: ["username": username, "password": password, "email": email], encoding: JSONEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        var defaultHeader = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        switch self {
        case .Register:
            return defaultHeader
        }
    }
}
