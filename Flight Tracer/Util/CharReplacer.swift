func replaceCharacters(in input: String) -> String {
    var result = input
    
    // Common character / number replacements
    let replacements: [Character: String] = [
        "/": "1",
        "\\": "1",
        "o": "0",
        "O": "0",
        "l": "1", // lowercase L
        "I": "1", // uppercase I
        "S": "5",
        "Z": "2",
        "z": "2"
    ]
    
    // Replace each character in the input string
    for (key, value) in replacements {
        result = result.replacingOccurrences(of: String(key), with: value)
    }
    
    return result
}
