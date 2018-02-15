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
    var components: [CSComponent] = [
        CSComponent(name: "Resistor", caption: "5 Umms", size: CGSize(width: 1, height: 1), image: "resistor"),
        CSComponent(name: "5v Battery", caption: "5v", size: CGSize(width: 1, height: 2), image: "battery"),
        CSComponent(name: "3v Battery", caption: "3v", size: CGSize(width: 1, height: 2), image: "battery"),
        CSComponent(name: "1v Battery", caption: "1v", size: CGSize(width: 1, height: 2), image: "battery")
    ] //FIXME: mock data
    
    var documentTitle: String = "Untitled" //FIXME: mock data
    
    var loggedInUser: CSUser = CSUser(username: "JohnnyApps", email: "e@d.com") //FIXME: mock data
}
