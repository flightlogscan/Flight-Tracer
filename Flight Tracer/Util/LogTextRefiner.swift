struct LogTextRefiner {

    // The advanced image scanner isn't perfect, so we attempt to refine the scan results after
    func refineLogText(unrefinedLogText: [[String]], logFieldMetadata: [LogFieldMetadata]) -> [[String]] {
        
        // Remove header rows (indices 0, 1, and 2) because we hardcode these depending on the user's selected log type
        var refinedLogText = Array(unrefinedLogText.dropFirst(3))
        
        // Remove blank rows
        refinedLogText = refinedLogText.filter { !isRowWhitespaceOrEmpty($0) }
        
        // Replace commonly mistaken characters in fields we know should be numbers, e.g. o and 0
        for rowIndex in 0..<refinedLogText.count {
            for columnIndex in 0..<refinedLogText[rowIndex].count {
                if columnIndex < logFieldMetadata.count, logFieldMetadata[columnIndex].type == .INTEGER {
                    refinedLogText[rowIndex][columnIndex] = replaceCharacters(in: refinedLogText[rowIndex][columnIndex])
                }
            }
        }
        
        return refinedLogText
    }
    
    private func isRowWhitespaceOrEmpty(_ row: [String]) -> Bool {
        return row.allSatisfy { $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }
    
    private func replaceCharacters(in input: String) -> String {
        var result = input
        let replacements: [Character: String] = [
            "/": "1",
            "\\": "1",
            "o": "0",
            "O": "0",
            "l": "1", 
            "I": "1", 
            "S": "5",
            "s": "5",
            "Z": "2",
            "z": "2"
        ]
        
        for (key, value) in replacements {
            result = result.replacingOccurrences(of: String(key), with: value)
        }
        return result
    }
}
