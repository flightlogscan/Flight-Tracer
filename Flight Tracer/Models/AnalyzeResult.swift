import SwiftUI

struct AnalyzeResult: Codable {
    let content: String
    let tables: [Table]
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
