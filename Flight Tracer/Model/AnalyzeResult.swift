import SwiftUI

struct RecognizedForm: Codable {
  let analyzeResult: AnalyzeResult?
}

struct AnalyzeResult: Codable {
    let content: String
    let tables: [Table]
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

enum ErrorCode: String {
    case TRANSIENT_FAILURE = "Something went wrong. Please try again"
    case MAX_SIZE_EXCEEDED = "Max size exceeded"
    case NO_RECOGNIZED_TEXT = "No recognized text"
}
