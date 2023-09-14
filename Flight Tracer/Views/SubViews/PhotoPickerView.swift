//
//  PhotoPickerView.swift
//  Flight Tracer
//
//  Created by Wilbur 😎 on 9/11/23.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct PhotoPickerView: View {
    
    @State private var selectedItems: [PhotosPickerItem] = []
    @ObservedObject var selectImageViewModel = SelectImageViewModel()
    @Binding var selectedImages: [ImageDetail]
    
    var body: some View {
        HStack {
            Spacer()
            PhotosPicker(selection: $selectedItems, matching: .images) {
                Label("Select photos", systemImage: "photo.fill")
                    .frame(maxWidth: .infinity)
            }
            .foregroundColor(Color.white)
            .buttonStyle(.borderedProminent)
            .onChange(of: selectedItems) { newItem in
                Task {
                    selectedImages = []
                    for item in selectedItems {
                        if let data = try? await item.loadTransferable(type: Data.self) {
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
            Spacer()
        }
    }
}
