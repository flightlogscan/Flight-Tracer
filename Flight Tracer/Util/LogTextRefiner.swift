struct LogTextRefiner {

    // The advanced image scanner isn't perfect, so we attempt to refine the scan results after
    func refineLogText(unrefinedLogText: [[String]], logFieldMetadata: [LogFieldMetadata]) -> [[String]] {
        
        // Remove header rows (indices 0, 1, and 2) because we hardcode these depending on the user's selected log type
        var refinedLogText = Array(unrefinedLogText.dropFirst(3))
        
        // Remove blank rows
        refinedLogText = refinedLogText.filter { !isRowWhitespaceOrEmpty($0) }
        refinedLogText = refinedLogText.filter { !containsUnwantedStrings($0) }
        
        // Replace commonly mistaken characters in fields we know should be numbers, e.g. o and 0
        var columnStartIndex = 0
        for metadata in logFieldMetadata {
            for columnIndex in columnStartIndex..<(columnStartIndex + metadata.columnCount) {
                for rowIndex in 0..<refinedLogText.count {
                    if metadata.type == .INTEGER { // (new)
                        refinedLogText[rowIndex][columnIndex] = replaceCharacters(in: refinedLogText[rowIndex][columnIndex])
                    }
                }
            }
            columnStartIndex += metadata.columnCount
        }
        
        return refinedLogText
    }
    
    private func isRowWhitespaceOrEmpty(_ row: [String]) -> Bool {
        return row.allSatisfy { $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }
    
    // New private function to remove rows containing specific strings
        private func containsUnwantedStrings(_ row: [String]) -> Bool {
            let unwantedStrings = ["I certify that", "TOTALS", "AMT. FORWARDED"]
            return row.contains { cell in
                unwantedStrings.contains { unwanted in
                    cell.localizedCaseInsensitiveContains(unwanted)
                }
            }
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
