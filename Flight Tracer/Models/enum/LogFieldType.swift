enum LogFieldType: String, Codable {
    case STRING
    case INTEGER
    case unknown // to handle invalid input

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self).uppercased()
        self = LogFieldType(rawValue: rawValue) ?? .unknown
    }
}
