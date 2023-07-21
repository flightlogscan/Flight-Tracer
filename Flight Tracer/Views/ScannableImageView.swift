//
//  WillImageView.swift
//  Flight Tracer
//
//  Created by William Janis on 7/6/23.
//

import Foundation
import SwiftUI

struct ScannableImageView: View {
    
    @Binding var selectedImage: UIImage?
    @State var imageText: [String] = ["no image text"]
    @State var processedImageText: [[String]] = [["no processed text"], ["no processed text"]]
    
    var body: some View {
        NavigationView {
            VStack (spacing: 69) {
                
                if let selectedImage = selectedImage {
                    
                    Image( uiImage: selectedImage )
                        .resizable()
                        .frame(width: 420, height: 420)
                    
                    let imageTextRecognizer = ImageTextRecognizer(imageText: $imageText)
                    let recogniedTextProcessor = RecognizedTextProcessor(processedImageText: $processedImageText)
                    
                    NavigationLink(destination: EditableLogGridView(imageText: processedImageText)) {
                        Text("Scan text")
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        imageTextRecognizer.scanImageForText(image: selectedImage)
                        recogniedTextProcessor.processText(imageText: imageText)
                    })
                    
                } else {
                    Text("Missing image")
                }
                
                Button {
                    selectedImage = nil
                } label: {
                    Text("Select a different image")
                }
            }
        }
    }
}
