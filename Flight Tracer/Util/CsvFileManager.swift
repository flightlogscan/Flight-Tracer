import Foundation

class CSVFileManager {
    static let shared = CSVFileManager()
    
    private init() {}
    
    func saveCSV(_ csv: String, fileName: String) -> URL? {
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent(fileName).appendingPathExtension("csv")
        
        do {
            try csv.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            // TODO: Potentially needs real UI error handling to let user know of CSV error?
            print("Failed to write CSV file: \(error)")
            return nil
        }
    }
}
