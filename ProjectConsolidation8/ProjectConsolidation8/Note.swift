//
//  Note.swift
//  ProjectConsolidation8
//
//  Created by Gustavo Isaac Lopez Nunez on 16/06/25.
//

import Foundation

struct Note: Codable {
    var id: String
    var title: String?
    var description: String?
    var noteText: String = "" {
        didSet {
            let noteSeparated = noteText.components(separatedBy: "\n")
            title = String(noteSeparated[0])
            
            if noteSeparated.count > 1 {
                description = String(noteSeparated[1])
            } else {
                description = "No additional text"
            }
        }
    }
}
