//
//  SelectImageView.swift
//  Flight Tracer
//
//  Created by Wilbur 😎 on 9/17/23.
//

import SwiftUI

struct SelectImageView: View {
    
    @Binding var selectedImages: [ImageDetail]
    
    var body: some View {
        
        HStack {
            CameraView(selectedImages: $selectedImages)
            PhotoPickerView(selectedImages: $selectedImages)
        }
    }
}

struct d: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

