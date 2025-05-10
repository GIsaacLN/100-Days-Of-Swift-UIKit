//
//  Picture.swift
//  ProjectConsolidation5
//
//  Created by Gustavo Isaac Lopez Nunez on 09/05/25.
//

import Foundation

class Picture: NSObject, Codable {
    var image: String
    var caption: String
    
    init(image: String, caption: String) {
        self.image = image
        self.caption = caption
    }
}
