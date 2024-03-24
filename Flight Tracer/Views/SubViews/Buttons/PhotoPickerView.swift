//
//  PhotoPickerView.swift
//  Flight Tracer
//
//  Created by Wilbur 😎 on 9/11/23.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct PhotoPickerView: View {
    
    let color: Color = Color.black.opacity(0.7)
    @Binding var selectedItem: PhotosPickerItem?
    @ObservedObject var selectImageViewModel = SelectImageViewModel()
    @Binding var selectedImage: ImageDetail
    
    var body: some View {
        PhotosPicker(selection: $selectedItem, matching: .images) {
            Rectangle()
                .overlay (
                    Image(systemName: "photo.fill")
                        .foregroundColor(color)
                )
                .foregroundColor(.white)
        }
        .cornerRadius(10)
        .aspectRatio(1, contentMode: .fit)
        .onChange(of: selectedItem) { oldItem, newItem in
            if (selectedItem != nil) {
                Task {
                    if let data = try? await newItem!.loadTransferable(type: Data.self) {
                        if let uiImage = UIImage(data: data) {
                            let image = Image(uiImage: uiImage)
                            
                            let imageDetail = ImageDetail(image: image, uiImage: uiImage, isValidated: true)
                            
                            selectedImage = imageDetail
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    UploadPageView(user: Binding.constant(nil))
}
