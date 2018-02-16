//
//  ViewController.swift
//  circuit-studio
//
//  Created by Erick Sanchez on 1/18/18.
//  Copyright © 2018 Circuit Studio. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON

class ViewController: UIViewController, CSDraggableDelegate {
    
    let viewModel = LoginViewModel()
    
    @IBOutlet var toolbarComponents: [CSDraggable]!
    
    private var gridSize: CGSize {
        let gridView = self.view as! GridView
        let size = CGFloat(gridView.minorGridSize)
        
        return CGSize(width: size, height: size)
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    // MARK: CSDraggable Delegate
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        viewModel.registerAndLogin(a: UserHTTPBody(username: "erickes4", email: "e@d.net", password: "longehough")) { (result) in
            switch result {
            case .success(let loginData):
                print(loginData)
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

