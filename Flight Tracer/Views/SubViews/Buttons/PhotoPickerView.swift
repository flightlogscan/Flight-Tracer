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
    @Binding var selectedImages: [ImageDetail]
    
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
                    selectedImages = []
                    if let data = try? await newItem!.loadTransferable(type: Data.self) {
                        if let uiImage = UIImage(data: data) {
                            let image = Image(uiImage: uiImage)
                            
                            let imageDetail = ImageDetail(image: image, uiImage: uiImage, isValidated: true)
                            
                            // This uses a very basic image scanner as a first-step sanity-check
                            // before allowing users to send the image to the more resource-intensive scanner
                            selectImageViewModel.simpleValidateImage(image: imageDetail)
                            
                            selectedImages.append(imageDetail)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    FlightLogUploadView(user: Binding.constant(nil))
}
