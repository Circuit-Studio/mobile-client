//
//  CSComponent.swift
//  circuit-studio
//
//  Created by Erick Sanchez on 2/15/18.
//  Copyright © 2018 Circuit Studio. All rights reserved.
//

import UIKit

typealias CSUUID = Int

struct CSComponent: Codable {
    let id: CSUUID
    let name: String
    
    struct CSNode: Codable {
        let id: CSUUID
        /** each point ranges from 1.0 to 0 representing 100% of each edge of the component's size */
        private let x: CGFloat
        private let y: CGFloat
        var origin: CGPoint {
            return CGPoint(x: self.x, y: self.y)
        }
        
        let sourceNodes: [CSNode]
        let terminalNodes: [CSNode]
    }
    let nodes: [CSNode]
    
    private let width: CGFloat
    private let height: CGFloat
    var size: CGSize {
        return CGSize(width: self.width, height: self.height)
    }
    
    let image: UIImage? = nil
    
    let caption: String
    /** each point ranges from 1.0 to 0 representing 100% */
    private let captionX: CGFloat
    private let captionY: CGFloat
    var captionOrigin: CGPoint {
        return CGPoint(x: self.captionX, y: self.captionY)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case nodes
        case width
        case height
        case caption
        case captionX = "caption-x"
        case captionY = "caption-y"
    }
}