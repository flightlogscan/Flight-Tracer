import Foundation

struct CSVExporter {
    /// Converts a StoredLog into a CSV-formatted string.
    static func export(_ log: StoredLog) -> String {

        guard !log.rows.isEmpty else {
            return ""
        }

        // Sort rows by rowIndex to ensure correct order
        let sortedRows = log.rows.sorted { $0.rowIndex < $1.rowIndex }

        // Extract header row (must exist) and its ordered keys
        guard let headerRow = sortedRows.first(where: { $0.header }) else {
            return ""
        }
        
        let headerKeys = headerRow.content.keys
            .sorted { Int($0) ?? 0 < Int($1) ?? 0 }

        var csvLines: [String] = []
        // Header line: use the header row’s values
        let headerValues = headerKeys.map { quote(headerRow.content[$0]! ) }
        csvLines.append(headerValues.joined(separator: ","))

        let dataRows = sortedRows.filter { !$0.header }
        for row in dataRows {
            let values = headerKeys.map { key in
                quote(row.content[key] ?? "")
            }
            csvLines.append(values.joined(separator: ","))
        }

        return csvLines.joined(separator: "\n")
    }

    /// Escapes a CSV field by wrapping in quotes if needed, and doubling internal quotes.
    private static func quote(_ value: String) -> String {
        var v = value.replacingOccurrences(of: "\"", with: "\"\"")
        if v.contains(",") || v.contains("\n") || v.contains("\"") {
            v = "\"\(v)\""
        }
        return v
    }
}
