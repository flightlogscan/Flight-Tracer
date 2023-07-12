//
//  ContentView.swift
//  Flight Tracer
//
//  Created by William Janis on 7/5/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var isPickerShowing = false
    @State var isTakerShowing = false
    @State var selectedImage: UIImage?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 69) {
                Text("Scan your flight log")
                
                Button {
                    isPickerShowing = true
                } label: {
                    Text("Select a Photo")
                }
                .sheet(isPresented: $isPickerShowing) {
                    ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
                }
                
                Button {
                    isTakerShowing = true
                } label: {
                    Text("Take a Photo")
                }
                .sheet(isPresented: $isTakerShowing) {
                    ImageTaker(selectedImage: $selectedImage, isTakerShowing: $isTakerShowing)
                }
                
                if (selectedImage != nil) {
                    Image(uiImage: selectedImage!)
                        .resizable()
                        .frame(width: 50, height: 50)
                    
                    NavigationLink(destination: ScannableImageView(image: selectedImage)) {
                        Text("Scan Image")
                            .foregroundStyle(.red)
                    }
                }
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
