import SwiftUI

struct RecognizedForm: Codable {
  let analyzeResult: AnalyzeResult?
}

struct AnalyzeResult: Codable, Equatable {
    static func == (lhs: AnalyzeResult, rhs: AnalyzeResult) -> Bool {
        print("lhs")
        print(lhs)
        print("rhs")
        print(rhs)
        return lhs.content == rhs.content
    }
    
    let content: String
    let tables: [Table]
    //let documents: [Document]
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
