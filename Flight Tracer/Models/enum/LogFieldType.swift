enum LogFieldType: String, Codable {
    case STRING
    case INTEGER
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self).uppercased()
        self = LogFieldType(rawValue: rawValue) ?? .unknown
    }
}
