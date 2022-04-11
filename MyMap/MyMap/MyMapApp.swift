//
//  MyMapApp.swift
//  MyMap
//
//  Created by Oksana on 09.04.2022.
//

import SwiftUI
import YandexMapsMobile

@main
struct MyMapApp: App {
    @StateObject var model = Model()
    
    init() {
        YMKMapKit.setApiKey("45b8d7c9-b613-4294-bb1d-c2ab0e07ccd9")
    }
    
    var body: some Scene {
        WindowGroup {
            NavTabView()
                .environmentObject(model)
        }
    }
}
