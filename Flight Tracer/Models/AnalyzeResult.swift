struct AnalyzeImageResponse: Codable {
   let status: String
   let rawResults: String?
   let tables: [RowDTO]?
}

struct RowDTO: Codable {
   let rowIndex: Int
   let content: [String: String]
   let header: Bool
   var parentHeaders: [String: String]?
}

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
