//
//  ScanView.swift
//  Flight Tracer
//
//  Created by Wilbur 😎 on 9/17/23.
//

import SwiftUI

struct ScanView: View {

    @Binding var allowScan: Bool
    @State var areImagesValid: Bool = false
    @Binding var selectedImages: [ImageDetail]
    @ObservedObject var contentViewModel = ContentViewModel()
    
    var body: some View {
        // Only allow scanning if every image is valid
        let areImagesValid = (selectedImages.count > 0 && !selectedImages.contains(where: {!$0.isImageValid}))
        
        Button {
            allowScan = areImagesValid
            //TODO: implement the call below for image text scanning
            // This is the legit scanner that will back the ultimate output going to the user
            if (allowScan) {
                contentViewModel.processImageText(images: selectedImages)
            }
        } label: {
            Label("Scan photo", systemImage: "doc.viewfinder.fill")
                .frame(maxWidth: .infinity)
                .font(.title2)
                .padding()
        }
        .buttonStyle(.borderedProminent)
        .tint(areImagesValid ? .green : .gray.opacity(0.5))
        .bold()
        .padding([.leading, .trailing])
    }
}
