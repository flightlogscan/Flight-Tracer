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
        Button {
            showCamera = true
        } label: {
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .overlay (
                    Image(systemName: "camera.fill")
                        .foregroundColor(color)
                )
                .foregroundColor(.white)
        }
        .cornerRadius(10)
        .aspectRatio(1, contentMode: .fit)
        .foregroundColor(color)
        .fullScreenCover(isPresented: $showCamera) {
            ImageTaker(selectedImages: $selectedImages)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black)
        }
    }
}

#Preview {
    FlightLogUploadView(user: Binding.constant(nil))
}
