//
//  RegisterService.swift
//  circuit-studio
//
//  Created by Erick Sanchez on 2/5/18.
//  Copyright © 2018 Circuit Studio. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

#if DEBUG
    var apiBaseUrl = "http://staging-api.circuit.studio"
#else
    var apiBaseUrl = "http://circuit.studio"
#endif
    

struct UserHTTPBody: Codable {
    let username: String? // 6 chars or more
    let email: String? // valid email
    let password: String? // 6 chars or more
}

enum CSAPIEndpoints {
    case Register(UserHTTPBody)
    case Login(UserHTTPBody)
}

extension CSAPIEndpoints: TargetType {
    var baseURL: URL {
        return URL(string: apiBaseUrl)!
    }
    
    var path: String {
        switch self {
        case .Register:
            return "/auth/register"
        case .Login:
            return "/auth/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .Register, .Login:
            return .post
        }
    }
    
    private func sampleData(for endpoint: CSAPIEndpoints) -> Data? {
        let key: String
        switch endpoint {
        case .Login:
            key = "login_successful"
        case .Register:
            key = "register_successful"
        }
        guard
            let jsonResponsesUrl = Bundle.main.url(forResource: "JSON Sample Data", withExtension: "json"),
            let jsonResponsesData = try? Data(contentsOf: jsonResponsesUrl),
            let jsonResponses = JSON(jsonResponsesData).dictionary,
            let sampleJson = jsonResponses[key]?.dictionaryObject else {
                return nil
        }
        
        return try? JSONSerialization.data(withJSONObject: sampleJson, options: .prettyPrinted)
    }
    
    var sampleData: Data {
        guard let data = sampleData(for: self) else {
            preconditionFailure("sample json response not mapped")
        }
        
        return data
    }
    
    var task: Task {
        switch self {
        case .Register(let user):
            return .requestJSONEncodable(user)
        case .Login(let user):
            return .requestJSONEncodable(user)
        }
    }
    
    var headers: [String : String]? {
        let defaultHeader = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        switch self {
        case .Register, .Login:
            return defaultHeader
        }
    }
}

