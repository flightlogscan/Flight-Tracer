struct MergedLogRow {
    let fieldValues: [String: String]
}

struct LogData {
    let headers: [String: String]
    let rows: [MergedLogRow]
}
