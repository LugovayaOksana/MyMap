//
//  HomeView.swift
//  MyMap
//
//  Created by Оксана on 10.04.2022.
//

import SwiftUI

struct HomeView: View {
    
    @State private var isPresented = false
    
    var body: some View {
        
        ZStack {
            Color.yellow
            
            Button {
                isPresented.toggle()
            } label: {
                HStack {
                    Image(systemName: "gear")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                    Text("Фильтры")
                        .font(.body)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.5), radius: 3, x: 1, y: 1)
                .padding()
            }
            .fullScreenCover(isPresented: $isPresented, content: FullScreenModalView.init)

        }
        
    }
}

struct FullScreenModalView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.primary.edgesIgnoringSafeArea(.all)
            Button("Dismiss Modal") {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
