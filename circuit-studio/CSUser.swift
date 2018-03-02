//
//  CSUser.swift
//  circuit-studio
//
//  Created by Erick Sanchez on 2/15/18.
//  Copyright © 2018 Circuit Studio. All rights reserved.
//

import Foundation

struct CSUser: Codable {
    let username: String?
    let email: String
    let password: String
    
    init(username: String? = nil, email: String, password: String) {
        self.username = username
        self.email = email
        self.password = password
    }
    
    static func currentUser() -> CSUser? {
        return PersistenceStack.user
    }
    
    static func logoutUser() {
        PersistenceStack.logoutUser()
    }
}
