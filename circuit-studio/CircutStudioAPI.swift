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
var apiBaseUrl = "http://staging-api.circuit.studio"

enum CSAPIStatusMessages {
    case Success
    case Failed(message: String)
}

struct RegisterUser: Codable {
    let username: String // 6 chars or more
    let email: String // valid email
    let password: String // 6 chars or more
}

enum CSAPIEndpoints {
    case Register(RegisterUser)
}

//TODO: use moya generated code
extension CSAPIEndpoints: TargetType {
    var baseURL: URL {
        return URL(string: apiBaseUrl)!
    }
    
    var path: String {
        switch self {
        case .Register:
            return "/auth/register"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .Register:
            return .post
        }
    }
    
    var sampleData: Data {
        return "Not implemented".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .Register(let user):
            return .requestJSONEncodable(user)
        }
    }
    
    var headers: [String : String]? {
        let defaultHeader = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        switch self {
        case .Register:
            return defaultHeader
        }
    }
}

