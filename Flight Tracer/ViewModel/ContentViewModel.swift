//
//  ContentViewModel.swift
//  Flight Tracer
//
//  Created by William Janis on 7/31/23.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    
    @Published var isLeftImageValid: Bool?
    @Published var isRightImageValid: Bool?
    @Published var areAllImagesValid: Bool = false
    let imageTextRecognizer = ImageTextRecognizer()
    let recognizedTextProcessor = RecognizedTextProcessor()
    @Published var leftImageGrid: [[String]] = [["left empty"]]
    @Published var rightImageGrid: [[String]] = [["right empty"]]
    @Published var mergedGrids: [[String]] = [["no merged grid"]]
        
    func checkAreAllImagesValid() -> Void {
        
        if isLeftImageValid != nil && isRightImageValid != nil {
            areAllImagesValid = isLeftImageValid! && isRightImageValid!
        }
    }
    
    func scanImage(image: UIImage?, pageSide: PageSide) -> [String] {
        
        var imageText = ["none yet"]
        if (image != nil) {
            
            imageTextRecognizer.scanImageForText(image: image!) { recognizedStrings in
                self.validate(imageText: recognizedStrings, pageSide: pageSide)
                imageText = recognizedStrings
            }
            
            return imageText
        }
        
        return ["failed scanImage"]
    }
    
    func processImageText(imageText: [String], pageSide: PageSide) {
        if (pageSide == PageSide.left) {
            self.leftImageGrid = recognizedTextProcessor.processText(imageText: imageText)
            print("leftProcessedImageText: \(String(describing: self.leftImageGrid))")
        } else if (pageSide == PageSide.right) {
            self.rightImageGrid = recognizedTextProcessor.processText(imageText: imageText)
            print("rightProcessedImageText: \(String(describing: self.rightImageGrid))")
        }
    }
    
    func mergeImageText(){
        self.mergedGrids = recognizedTextProcessor.mergeArrays(leftImageGrid, rightImageGrid)
    }
    
    private func validate(imageText: [String], pageSide: PageSide) {
        if(pageSide == PageSide.left) {
            if (imageText.contains { text in
                return text.contains("DATE")
            }) {
                isLeftImageValid = true
            } else {
                isLeftImageValid = false
            }
        } else if(pageSide == PageSide.right) {
            if (imageText.contains { text in
                return text.contains("CONDITIONS")
            }) {
                isRightImageValid = true
            } else {
                isRightImageValid = false
            }
        }
    }
    
    //test
}
