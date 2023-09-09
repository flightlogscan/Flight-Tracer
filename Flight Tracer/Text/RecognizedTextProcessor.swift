//
//  RecognizedTextProcessor.swift
//  Flight Tracer
//
//  Created by William Janis on 7/19/23.
//

import Foundation
import SwiftUI

struct RecognizedTextProcessor {
        
    func processText(imageText: [String]) -> [[String]] {
        return [["test", "test2"], ["text", "text2"]]
        //return convertTo2DArray(strings: imageText, columns: 10)
    }
    
//    private func convertTo2DArray(strings: [String], columns: Int) -> [[String]] {
//        let rows = (strings.count + columns - 1) / columns
//        let paddedElements = strings + Array(repeating: "" , count: rows * columns - strings.count)
//        let processedImageText = paddedElements.chunked(into: columns)
//        print("processed text \(processedImageText)")
//        return processedImageText
//    }
}
