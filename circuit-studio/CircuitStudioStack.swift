//
//  CircuitStudioStack.swift
//  circuit-studio
//
//  Created by Erick Sanchez on 2/6/18.
//  Copyright © 2018 Circuit Studio. All rights reserved.
//

import Foundation

struct CircuitStudioStack {
    static var shared = CircuitStudioStack()
    
    var networkService = CircuitStudioNeworkService()
}
