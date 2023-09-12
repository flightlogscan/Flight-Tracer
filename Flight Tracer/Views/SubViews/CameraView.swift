//
//  CameraView.swift
//  Flight Tracer
//
//  Created by Wilbur 😎 on 9/11/23.
//

import SwiftUI

struct CameraView: View {
    
    @Binding var selectedImages: [ImageDetail]
    @State private var showCamera: Bool = false
    
    var body: some View {
        Button {
            showCamera = true
        } label: {
            Text("Take a picture")
        }
        .fullScreenCover(isPresented: $showCamera) {
            ImageTaker(selectedImages: $selectedImages)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.black)
        }
        .foregroundColor(Color.white)
        .buttonStyle(.borderedProminent)

    }
}
