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
        return convertTo2DArray(strings: imageText, columns: 10)
    }
    
    private func convertTo2DArray(strings: [String], columns: Int) -> [[String]] {
        let rows = (strings.count + columns - 1) / columns
        let paddedElements = strings + Array(repeating: "" , count: rows * columns - strings.count)
        let processedImageText = paddedElements.chunked(into: columns)
        print("processed text \(processedImageText)")
        return processedImageText
    }
    
    func mergeArrays(_ array1: [[String]], _ array2: [[String]]) -> [[String]] {
        guard !(array1.isEmpty || array2.isEmpty) else {
            return []
        }
        
        var mergedArray: [[String]] = []
        let rowCount = max(array1.count, array2.count)
        
        for i in 0..<rowCount {
            var row: [String] = []
            
            if i < array1.count {
                row += array1[i]
            }
            
            if i < array2.count {
                row += array2[i]
            }
            
            mergedArray.append(row)
        }
        
        return mergedArray
    }
}
