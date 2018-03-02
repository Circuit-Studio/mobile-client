//
//  KeychainsStack.swift
//  circuit-studio
//
//  Created by Erick Sanchez on 2/12/18.
//  Copyright © 2018 Circuit Studio. All rights reserved.
//

import Foundation
import KeychainSwift

struct PersistenceStack {
    
    fileprivate static let LOGGED_IN_TOKEN = "LOGGED_IN_TOKEN"
    static var userToken: String? {
        set {
            let keychain = KeychainSwift()
            if let token = newValue {
                keychain.set(token, forKey: LOGGED_IN_TOKEN)
            } else {
                keychain.delete(LOGGED_IN_TOKEN)
            }
        }
        get {
            let keychain = KeychainSwift()
            
            return keychain.get(LOGGED_IN_TOKEN)
        }
    }
    
    fileprivate static let LOGGED_IN_USER_ID = "LOGGED_IN_USER_ID"
    static var userId: String? {
        set {
            let userDefaults = UserDefaults.standard
            userDefaults.set(newValue, forKey: LOGGED_IN_USER_ID)
            userDefaults.synchronize()
        }
        get {
            let ud = UserDefaults.standard
            
            return ud.string(forKey: LOGGED_IN_USER_ID)
        }
    }
    
    fileprivate static let LOGGED_IN_USER = "LOGGED_IN_USER"
    static var user: CSUser? {
        set {
            let keychain = KeychainSwift()
            if let user = newValue {
                guard let userData = try? JSONEncoder().encode(user) else {
                    fatalError("Cannot encode CSUser")
                }
                
                keychain.set(userData, forKey: LOGGED_IN_USER)
            } else {
                keychain.delete(LOGGED_IN_USER)
            }
        }
        get {
            let keychain = KeychainSwift()
            
            if let userData = keychain.get(LOGGED_IN_USER) as! Data? {
                guard let user = try? JSONDecoder().decode(CSUser.self, from: userData) else {
                    fatalError("Cannot decode CSUser")
                }
                
                return user
            } else {
                return nil
            }
        }
    }
}
