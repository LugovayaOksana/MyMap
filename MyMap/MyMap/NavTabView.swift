//
//  HomeView.swift
//  MyMap
//
//  Created by Oksana on 10.04.2022.
//

import SwiftUI

struct NavTabView: View {
    
    init(){
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().barTintColor = UIColor.white
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Home")
                }
            YMKView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
        }
    }
}

struct NavTabView_Previews: PreviewProvider {
    static var previews: some View {
        NavTabView()
    }
}
