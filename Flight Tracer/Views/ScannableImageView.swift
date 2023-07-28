//
//  WillImageView.swift
//  Flight Tracer
//
//  Created by William Janis on 7/6/23.
//

import Foundation
import SwiftUI

struct ScannableImageView: View {
    
    var pageSide: PageSide
    @Binding var selectedImage: UIImage?
    @State var imageText: [String] = ["no image text"]
    @State var processedImageText: [[String]] = [["no processed text"], ["no processed text"]]
    
    var body: some View {
        NavigationView {
            VStack (spacing: 37) {
                
                if let selectedImage = selectedImage {
                    
                    let imageTextRecognizer = ImageTextRecognizer(imageText: $imageText)
                    let recogniedTextProcessor = RecognizedTextProcessor(processedImageText: $processedImageText)
                    
                    NavigationLink(destination: EditableLogGridView(imageText: processedImageText)) {
                        Text("Scan \(pageSide.rawValue) text")
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        imageTextRecognizer.scanImageForText(image: selectedImage)
                        recogniedTextProcessor.processText(imageText: imageText)
                        
                        if(pageSide == PageSide.left) {
                            if (!imageText.contains { text in
                                return text.contains("DATE")
                            }) {
                                processedImageText = [["not left"]]
                            }
                        }
                        
                        if(pageSide == PageSide.right) {
                            if (!imageText.contains { text in
                                return text.contains("CONDITIONS")
                            }) {
                                processedImageText = [["not right"]]
                            }
                        }
                    })
                    
                } else {
                    Text("Missing image")
                }
                
                
            }
        }
    }
}
