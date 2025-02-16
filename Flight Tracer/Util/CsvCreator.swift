import Foundation

class CSVCreator {
    static func createCSVFile(_ logData: LogData, filename: String) -> URL? {
        // Sort keys numerically
        let sortedKeys = logData.headers.keys.sorted {
            (Int($0) ?? 0) < (Int($1) ?? 0)
        }
        
        // Create header line
        let headerLine = sortedKeys.map {
            logData.headers[$0]?
                .replacingOccurrences(of: ",", with: "")
                .replacingOccurrences(of: "\n", with: "") ?? ""
        }.joined(separator: ",")
        
        // Create data lines
        let dataLines = logData.rows.map { row in
            sortedKeys.map {
                row.fieldValues[$0]?
                    .replacingOccurrences(of: ",", with: "")
                    .replacingOccurrences(of: "\n", with: "") ?? ""
            }.joined(separator: ",")
        }
        
        // Combine header and data
        let csvString = ([headerLine] + dataLines).joined(separator: "\n")
        
        return writeCSVToFile(csvString, filename: filename)
    }
    
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
