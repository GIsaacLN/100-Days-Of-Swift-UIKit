//
//  Capital.swift
//  Project16
//
//  Created by Gustavo Isaac Lopez Nunez on 28/05/25.
//

import MapKit
import UIKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    var urlExtension: String
    
    init(title: String? = nil, coordinate: CLLocationCoordinate2D, info: String, urlExtension: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.urlExtension = urlExtension
    }

}
