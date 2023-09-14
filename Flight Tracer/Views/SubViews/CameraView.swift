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
        HStack {
            Spacer()
            Button {
                showCamera = true
            } label: {
                Label("Take a photo", systemImage: "camera.fill")
                    .frame(maxWidth: .infinity)
            }
            .fullScreenCover(isPresented: $showCamera) {
                ImageTaker(selectedImages: $selectedImages)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.black)
            }
            .foregroundColor(Color.white)
            .buttonStyle(.borderedProminent)
            Spacer()
        }
    }
}
