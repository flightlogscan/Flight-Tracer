//
//  ContentView.swift
//  Flight Tracer
//
//  Created by William Janis on 7/5/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var isPickerShowing = false
    @State var selectedImage: UIImage?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 69) {
                Button {
                    isPickerShowing = true
                } label: {
                    Text("Select a Photo")
                }
                
                NavigationLink(destination: WillImageView(image: selectedImage)) {
                    Text("Do Something")
                        .foregroundStyle(.red)
                }
            }
            .sheet(isPresented: $isPickerShowing) {
                ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
