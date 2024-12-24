func convertToArray(analyzeResult: AnalyzeResult, logFieldMetadata: [LogFieldMetadata]) -> [[String]] {
    
    let columnCount = logFieldMetadata.reduce(0) { $0 + $1.columnCount }
    
    // Tables 1 and 3 because there is a "Totals" table on the log that we don't use
    // TODO: Is this unique to Jeppesen or do other logs have this too?
    let originalTables: [Table]
    
    switch analyzeResult.tables.count {
    case 3: // If there are 3 tables (indices 0, 1, 2)
        originalTables = [analyzeResult.tables[0], analyzeResult.tables[2]]
    case 2: // If there are 2 tables (indices 0, 1)
        originalTables = [analyzeResult.tables[0], analyzeResult.tables[1]]
    case 1: // If there is only 1 table (index 0)
        originalTables = [analyzeResult.tables[0]]
    default: // Fallback for unexpected cases
        originalTables = []
    }
    
    // form recognizer sometimes views the edge of the page as an empty first column
    // if it does, remove it
    let tables: [Table] = originalTables.enumerated().map { index, table in
        guard index == 0 else { return table } // Only modify the first table
        
        if table.cells.allSatisfy({ $0.columnIndex != 0 || $0.content.isEmpty }) {
            // Create new cells with adjusted column indices
            let updatedCells = table.cells.map { cell in
                Cell(rowIndex: cell.rowIndex, columnIndex: cell.columnIndex > 0 ? cell.columnIndex - 1 : cell.columnIndex, content: cell.content)
            }
            // Return a new Table instance with updated cells and column count
            return Table(rowCount: table.rowCount, columnCount: table.columnCount - 1, cells: updatedCells)
        }
        
        return table
    }
    
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
    
    print("analyze result converted array: \(resultArray)")
    return resultArray
}
