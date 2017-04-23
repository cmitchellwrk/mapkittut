//
//  CityLocation.swift
//  mapkittut
//
//  Created by Chris Mitchell on 4/16/17.
//  Copyright © 2017 Chris Mitchell. All rights reserved.
//


import Foundation
import MapKit

class CityLocation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
