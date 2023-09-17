//
//  AnalyzeResult.swift
//  Flight Tracer
//
//  Created by Wilbur 😎 on 9/17/23.
//

import SwiftUI

struct RecognizedForm: Codable {
  let analyzeResult: AnalyzeResult
}

struct AnalyzeResult: Codable {
    let content: String
    let tables: [Table]
    let documents: [Document]
}

struct Document: Codable {
    let fields: [String : FieldData]
}

struct FieldData: Codable {
    let confidence: Float
}

struct Table: Codable {
    let rowCount: Int
    let columnCount: Int
    let cells: [Cell]
}

struct Cell: Codable {
    let rowIndex: Int
    let columnIndex: Int
    let content: String
}
