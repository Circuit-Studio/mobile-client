//
//  Network+RegisterTests.swift
//  circuit-studioTests
//
//  Created by Erick Sanchez on 2/6/18.
//  Copyright © 2018 Circuit Studio. All rights reserved.
//

import XCTest
@testable import circuit_studio

class NetworkRegiserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        
    }
    
    func test_register_user_invalid_email() {
        let user = RegisterUser(
            username: "unique",
            email: "bad@bad",
            password: "password_that_is_long_enough"
        )
        
        let testEmail = XCTestExpectation(description: "email")
        
        CircuitStudioStack.shared.register(a: user) { (result) in
            switch result {
            case .success:
                XCTAssert(false, "should not succeed with an invalid email")
            case .failure(let registerError):
                XCTAssertEqual(registerError.errors.count, 1)
                for aError in registerError.errors {
                    switch aError {
                    case .InvalidEmail:
                        testEmail.fulfill()
                    default:
                        XCTAssert(false, "should not hit any other error")
                    }
                }
            }
        }
        self.wait(for: [testEmail], timeout: 10)
    }

    func test_register_user_invalid_email_username() {
        let user = RegisterUser(
            username: "bad",
            email: "bad@bad",
            password: "password_that_is_long_enough"
        )
        
        let testUsername = XCTestExpectation(description: "username")
        let testEmail = XCTestExpectation(description: "email")
        
        CircuitStudioStack.shared.register(a: user) { (result) in
            switch result {
            case .success:
                XCTAssert(false, "should not succeed with an invalid username")
            case .failure(let registerError):
                XCTAssertEqual(registerError.errors.count, 2)
                for aError in registerError.errors {
                    switch aError {
                    case .InvalidUsername:
                        testUsername.fulfill()
                    case .InvalidEmail:
                        testEmail.fulfill()
                    default:
                        XCTAssert(false, "should not hit any other error")
                    }
                }
            }
        }
        self.wait(for: [testUsername, testEmail], timeout: 10)
    }
    
    func test_register_user_invalid_email_password() {
        let user = RegisterUser(
            username: "unique",
            email: "bad@bad",
            password: "bad"
        )
        
        let testEmail = XCTestExpectation(description: "email")
        let testPassword = XCTestExpectation(description: "password")
        
        CircuitStudioStack.shared.register(a: user) { (result) in
            switch result {
            case .success:
                XCTAssert(false, "should not succeed with an invalid email and password")
            case .failure(let registerError):
                XCTAssertEqual(registerError.errors.count, 2)
                for aError in registerError.errors {
                    switch aError {
                    case .InvalidEmail:
                        testEmail.fulfill()
                    case .InvalidPassword:
                        testPassword.fulfill()
                    default:
                        XCTAssert(false, "should not hit any other error")
                    }
                }
            }
        }
        self.wait(for: [testEmail, testPassword], timeout: 10)
    }

    func test_register_user_invalid_email_username_password() {
        let user = RegisterUser(
            username: "bad",
            email: "bad@bad",
            password: "bad"
        )
        
        let testUsername = XCTestExpectation(description: "username")
        let testEmail = XCTestExpectation(description: "email")
        let testPassword = XCTestExpectation(description: "password")
        
        CircuitStudioStack.shared.register(a: user) { (result) in
            switch result {
            case .success:
                XCTAssert(false, "should not succeed with an invalid username")
            case .failure(let registerError):
                XCTAssertEqual(registerError.errors.count, 3)
                for aError in registerError.errors {
                    switch aError {
                    case .InvalidUsername:
                        testUsername.fulfill()
                    case .InvalidEmail:
                        testEmail.fulfill()
                    case .InvalidPassword:
                        testPassword.fulfill()
                    default:
                        XCTAssert(false, "should not hit any other error")
                    }
                }
            }
        }
        self.wait(for: [testUsername, testEmail, testPassword], timeout: 10)
    }
    
    func test_register_user_invalid_password() {
        let user = RegisterUser(
            username: "unique",
            email: "unique@unique.unique",
            password: "bad"
        )
        
        let testPassword = XCTestExpectation(description: "password")
        
        CircuitStudioStack.shared.register(a: user) { (result) in
            switch result {
            case .success:
                XCTAssert(false, "should not succeed with an invalid password")
            case .failure(let registerError):
                XCTAssertEqual(registerError.errors.count, 1)
                for aError in registerError.errors {
                    switch aError {
                    case .InvalidPassword:
                        testPassword.fulfill()
                    default:
                        XCTAssert(false, "should not hit any other error")
                    }
                }
            }
        }
        self.wait(for: [testPassword], timeout: 10)
    }
    
    func test_register_user_invalid_password_username() {
        let user = RegisterUser(
            username: "bad",
            email: "unique@unique.unique",
            password: "bad"
        )
        
        let testPassword = XCTestExpectation(description: "password")
        let testUsername = XCTestExpectation(description: "username")
        
        CircuitStudioStack.shared.register(a: user) { (result) in
            switch result {
            case .success:
                XCTAssert(false, "should not succeed with an invalid password")
            case .failure(let registerError):
                XCTAssertEqual(registerError.errors.count, 2)
                for aError in registerError.errors {
                    switch aError {
                    case .InvalidUsername:
                        testUsername.fulfill()
                    case .InvalidPassword:
                        testPassword.fulfill()
                    default:
                        XCTAssert(false, "should not hit any other error")
                    }
                }
            }
        }
        self.wait(for: [testPassword, testUsername], timeout: 10)
    }
    
    func test_register_user_invalid_username() {
        let user = RegisterUser(
            username: "bad",
            email: "unique@unique.unique",
            password: "password_that_is_long_enough"
        )
        
        let testUsername = XCTestExpectation(description: "username")
        
        CircuitStudioStack.shared.register(a: user) { (result) in
            switch result {
            case .success:
                XCTAssert(false, "should not succeed with an invalid username")
            case .failure(let registerError):
                XCTAssertEqual(registerError.errors.count, 1)
                for aError in registerError.errors {
                    switch aError {
                    case .InvalidUsername:
                        testUsername.fulfill()
                    default:
                        XCTAssert(false, "should not hit any other error")
                    }
                }
            }
        }
        self.wait(for: [testUsername], timeout: 10)
    }
    
}

