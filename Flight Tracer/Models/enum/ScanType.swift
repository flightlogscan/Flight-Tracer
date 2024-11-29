enum ScanType: CaseIterable, Identifiable {
    case localhost
    case api
    case hardcoded
    
    var id: Self { self }

    var displayName: String {
        switch self {
        case .localhost: return "Localhost call"
        case .api: return "Real API call"
        case .hardcoded: return "Hardcoded data"
        }
    }
}
