import Foundation

public class JsonLoader {
    
    public struct Field: Codable {
        let fieldName: String
        let columnCount: Int
    }

    
    public static func loadJSONFromFile(named fileName: String) -> [Field]? {
        guard
            let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
            let data = try? Data(contentsOf: url)
        else {
            print("Failed to load \(fileName).json")
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let fields = try decoder.decode([Field].self, from: data)
            return fields
        } catch {
            print("Failed to decode JSON: \(error)")
            return nil
        }
    }

}
