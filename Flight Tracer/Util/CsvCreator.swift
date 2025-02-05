import Foundation

class CSVCreator {
    static func createCSVFile<T>(_ array: [[T]], filename: String) -> URL? {
        let csvString = array.map { row in row.map { String(describing: $0) }.joined(separator: ",") }.joined(separator: "\n")
        
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

