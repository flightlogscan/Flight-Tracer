import Foundation

class CSVCreator {
    // Keep the generic version for other uses
    static func createCSVFile<T>(_ array: [[T]], filename: String) -> URL? {
        let csvString = array.map { row in row.map { String(describing: $0) }.joined(separator: ",") }.joined(separator: "\n")
        return writeCSVToFile(csvString, filename: filename)
    }
    
    // Add specific version for RowDTOs
    static func createCSVFile(_ rows: [RowDTO], filename: String) -> URL? {
        // Get header row
        guard let headerRow = rows.first(where: { $0.header }) else {
            return nil
        }
        
        // Get all keys sorted numerically
        let sortedKeys = headerRow.content.keys.sorted { Int($0) ?? 0 < Int($1) ?? 0 }
        
        // Create header line using sorted keys
        let headerLine = sortedKeys.map { headerRow.content[$0] ?? "" }.joined(separator: ",")
        
        // Create data lines
        let dataRows = rows.filter { !$0.header }
        let dataLines = dataRows.map { row in
            sortedKeys.map { row.content[$0] ?? "" }.joined(separator: ",")
        }
        
        // Combine header and data
        let csvString = ([headerLine] + dataLines).joined(separator: "\n")
        
        return writeCSVToFile(csvString, filename: filename)
    }
    
    // Helper method to write string to file
    private static func writeCSVToFile(_ csvString: String, filename: String) -> URL? {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(filename)
            
            do {
                try csvString.write(to: fileURL, atomically: false, encoding: .utf8)
                return fileURL
            } catch {
                print("Error writing CSV file:", error)
            }
        }
        
        return nil
    }
}
