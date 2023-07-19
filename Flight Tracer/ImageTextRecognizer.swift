//
//  ImageTextScanner.swift
//  Flight Tracer
//
//  Created by William Janis on 7/6/23.
//

import Foundation
import Vision
import VisionKit
import SwiftUI


final class ImageTextRecognizer {
    
    @Binding var imageText: [[String]]
    
    init(imageText: Binding<[[String]]>) {
        self._imageText = imageText
    }
    
    func scanImageForText(image: UIImage) {
        
        guard let cgImage = image.cgImage else { return }
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
        request.usesLanguageCorrection = true

        do {
            // Perform the text-recognition request.
            try requestHandler.perform([request])
            
            
        } catch {
            print("Unable to perform the requests: \(error).")
        }
    }
    
    func recognizeTextHandler(request: VNRequest, error: Error?) {
        
        if let observations = request.results as? [VNRecognizedTextObservation] {
            let recognizedStrings = observations.map { observation -> String in
                // Return the string of the top VNRecognizedText instance.
                return observation.topCandidates(1).first?.string ?? "notfound"
            }
            
            processResults(recognizedStrings: recognizedStrings)
        } else {
            // Handle the case where request.results is not [VNRecognizedTextObservation].
            print("failed to recognize text.")
            return
        }
    }
    
    func processResults(recognizedStrings: [String]) {
        imageText = convertTo2DArray(strings: recognizedStrings, columns: 10)
        print("image table \(imageText)")
    }
    

    func convertTo2DArray<String>(strings: [String], columns: Int) -> [[String]] {
        let rows = (strings.count + columns - 1) / columns
        let paddedElements = strings + Array(repeating: "" as! String, count: rows * columns - strings.count)
        return paddedElements.chunked(into: columns)
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

