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
        YMKMapKit.setApiKey("KEY")
    }
    
    var body: some Scene {
        WindowGroup {
            NavTabView()
                .environmentObject(model)
        }
    }
}
