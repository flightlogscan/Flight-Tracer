//
//  RecognizedTextProcessor.swift
//  Flight Tracer
//
//  Created by William Janis on 7/19/23.
//

import Foundation
import SwiftUI

struct RecognizedTextProcessor {
    
    @Binding var processedImageText: [[String]]
    
    init(processedImageText: Binding<[[String]]>) {
        self._processedImageText = processedImageText
    }
    
    func processText(imageText: [String]) {
        convertTo2DArray(strings: imageText, columns: 10)
    }
    
    func convertTo2DArray(strings: [String], columns: Int) {
        let rows = (strings.count + columns - 1) / columns
        let paddedElements = strings + Array(repeating: "" , count: rows * columns - strings.count)
        processedImageText = paddedElements.chunked(into: columns)
        print("processed text \(processedImageText)")
    }
}
