import Foundation

public class LogMetadataLoader {
    
    public static func getLogMetadata(named fileName: String) -> [LogFieldMetadata] {
        guard
            let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
            let data = try? Data(contentsOf: url)
        else {
            print("Failed to load \(fileName).json")
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            let fields = try decoder.decode([LogFieldMetadata].self, from: data)
            return fields
        } catch {
            print("Failed to decode JSON: \(error)")
            return []
        }
    }

}
