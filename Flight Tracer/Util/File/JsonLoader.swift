import Foundation

public class JsonLoader {
    
    public struct Field: Codable {
        let fieldName: String
        let columnCount: Int
        let type: String
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

enum FieldType: Codable {
    case STRING
    case INTEGER
    case unknown // to handle invalid input

    init(from string: String) {
        switch string.uppercased() {
        case "STRING":
            self = .STRING
        case "INTEGER":
            self = .INTEGER
        default:
            self = .unknown
        }
    }
}
