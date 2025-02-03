func convertToArray(analyzeResult: AnalyzeResult, logFieldMetadata: [LogFieldMetadata], tables: [RowDTO]) -> [[String]] {
    print("Analyze result tables: ")
    print(analyzeResult.tables)
    
    let columnCount = logFieldMetadata.reduce(0) { $0 + $1.columnCount }
    
    // Find the maximum row index
    let maxRowCount = tables.map { $0.rowIndex }.max() ?? 0
    
    // Initialize result array
    var resultArray = Array(repeating: Array(repeating: "", count: columnCount), count: maxRowCount + 1)
    
    // Process each row
    for rowDTO in tables {
        let rowIndex = rowDTO.rowIndex + 1 // Add 1 to match the old behavior
        
        // Process each column in the row's content
        for (columnKey, content) in rowDTO.content {
            if let columnIndex = Int(columnKey) { // Convert string key to integer
                if rowIndex < resultArray.count && columnIndex < resultArray[rowIndex].count {
                    resultArray[rowIndex][columnIndex] = content
                }
            }
        }
    }
    
    print("analyze result converted array: \(resultArray)")
    return resultArray
}
