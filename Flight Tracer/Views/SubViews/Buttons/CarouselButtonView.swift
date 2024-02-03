//
//  CarouselButtonView.swift
//  Flight Tracer
//
//  Created by Wilbur 😎 on 11/30/23.
//

import SwiftUI

struct CarouselButtonView: View {
    
    var thumbnailImage: UIImage
    var hiResImage: UIImage
    @ObservedObject var selectImageViewModel = SelectImageViewModel()
    @Binding var selectedImages: [ImageDetail]
    
    var body: some View {
        Button {
            let image = Image(uiImage: hiResImage)
            let imageDetail = ImageDetail(image: image, uiImage: hiResImage, isValidated: true)
            
            // This uses a very basic image scanner as a first-step sanity-check
            // before allowing users to send the image to the more resource-intensive scanner
            selectImageViewModel.simpleValidateImage(image: imageDetail)
            
            selectedImages = []
            selectedImages.append(imageDetail)
            
        } label: {
            Image(uiImage: thumbnailImage)
                .resizable()
        }
        .cornerRadius(10)
        .aspectRatio(1, contentMode: .fit)
    }
}
