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
}
