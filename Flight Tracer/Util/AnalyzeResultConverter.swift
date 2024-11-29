func convertToArray(analyzeResult: AnalyzeResult, logFieldMetadata: [LogFieldMetadata]) -> [[String]] {
    
    let columnCount = logFieldMetadata.reduce(0) { $0 + $1.columnCount }
    
    // Tables 1 and 3 because there is a "Totals" table on the log that we don't use
    // TODO: Is this unique to Jeppesen or do other logs have this too?
    let tables = analyzeResult.tables.indices.contains(2) ? [analyzeResult.tables[0], analyzeResult.tables[2]] : [analyzeResult.tables[0]]
    
    let maxRowCount = tables.reduce(0) { max($0, $1.rowCount) }
    
    var resultArray = Array(repeating: Array(repeating: "", count: columnCount), count: maxRowCount + 1)
    
    var columnOffset = 0

    for table in tables {
        for cell in table.cells {
            let rowIndex = cell.rowIndex + 1
            let columnIndex = columnOffset + cell.columnIndex
            
            if rowIndex < resultArray.count && columnIndex < resultArray[rowIndex].count {
                resultArray[rowIndex][columnIndex] = cell.content
            }
        }
        columnOffset += table.columnCount
    }
    
    return resultArray
}
