func toArray(rowViewModels: [LogRowViewModel]) -> [[String]] {
    let logMetadata = LogMetadataLoader.getLogMetadata(named: "JeppesenLogFormat")
    
    let fieldNamesRow = logMetadata.flatMap { Array(repeating: $0.fieldName, count: $0.columnCount) }
    
    let logRows = rowViewModels.map { $0.fields }
    
    print("logRows: \(logRows)")
    
    return [fieldNamesRow] + logRows
}
