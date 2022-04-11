//
//  Model.swift
//  MyMap
//
//  Created by Oksana on 09.04.2022.
//

import SwiftUI
import Combine
import MapKit
import CoreLocation

class Model: ObservableObject {
    
    // Map
    @Published var mapView = MKMapView()
   
    // Alert...
    @Published var permissionDenied = false
    
    @Published var zoomIn: Bool = false
    @Published var zoomOut: Bool = false
    @Published var showUserLocation: Bool = false
}
