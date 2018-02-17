//
//  CanvasViewModel.swift
//  circuit-studio
//
//  Created by Erick Sanchez on 2/15/18.
//  Copyright © 2018 Circuit Studio. All rights reserved.
//

import Foundation
//TODO: REMOVE UIKIT
import UIKit

struct CanvasViewModel {
    var documentTitle: String = "Untitled" //FIXME: mock data
    
    var loggedInUser: CSUser = CSUser(username: "JohnnyApps", email: "e@d.com") //FIXME: mock data
    
    var components: [CSComponent] = [
        CSComponent(name: "Resistor", caption: "5 Umms", size: CGSize(width: 1, height: 1), image: "resistor"),
        CSComponent(name: "Capacitor", caption: "5v", size: CGSize(width: 1, height: 2), image: "capacitor"),
        CSComponent(name: "Diode", caption: "3v", size: CGSize(width: 1, height: 2), image: "diode"),
        CSComponent(name: "Switch", caption: "1v", size: CGSize(width: 1, height: 2), image: "switch"),
        CSComponent(name: "Transistor", caption: "1v", size: CGSize(width: 1, height: 2), image: "transistor")
    ] //FIXME: mock data
    
}
