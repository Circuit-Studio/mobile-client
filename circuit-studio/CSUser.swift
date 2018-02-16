//
//  CSUser.swift
//  circuit-studio
//
//  Created by Erick Sanchez on 2/15/18.
//  Copyright © 2018 Circuit Studio. All rights reserved.
//

import Foundation

struct CSUser: Codable {
    let username: String
    let email: String
    
    init(username: String, email: String) {
        self.username = username
        self.email = email
    }
}
