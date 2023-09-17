//
//  CameraView.swift
//  Flight Tracer
//
//  Created by Wilbur 😎 on 9/11/23.
//

import SwiftUI

struct CameraView: View {
    
    let color = Color.black.opacity(0.7)
    @Binding var selectedImages: [ImageDetail]
    @State private var showCamera: Bool = false
    
    var body: some View {
        HStack {
            Button {
                showCamera = true
            } label: {
                VStack {
                    Image(systemName: "camera.fill")
                        .padding(.bottom, 1)
                    
                    Text("camera")
                        .font(.headline)
                        .foregroundColor(color) // Customize text appearance as needed
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .fullScreenCover(isPresented: $showCamera) {
                ImageTaker(selectedImages: $selectedImages)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.black)
            }
            .foregroundColor(color)
            .buttonStyle(.borderedProminent)
            .tint(.white)
            .padding(.leading)
        }
    }
}

struct x: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
