struct LogTextRefiner {
    
    func refineLogText(unrefinedLogText: [[String]], logFieldMetadata: [LogFieldMetadata]) -> [[String]] {
        var refinedLogText = unrefinedLogText
        
        for rowIndex in 3..<refinedLogText.count {
            for columnIndex in 0..<refinedLogText[rowIndex].count {
                if columnIndex < logFieldMetadata.count, logFieldMetadata[columnIndex].type == .INTEGER {
                    refinedLogText[rowIndex][columnIndex] = replaceCharacters(in: refinedLogText[rowIndex][columnIndex])
                }
            }
        }
        return refinedLogText
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
