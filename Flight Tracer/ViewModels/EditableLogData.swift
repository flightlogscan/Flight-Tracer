import Foundation

struct LogEdits {
    var contentEdits: [Int: [String: String]] = [:]
    var headerEdits: [String: String] = [:]
    
    var hasEdits: Bool {
        return !contentEdits.isEmpty || !headerEdits.isEmpty
    }
}

class EditableLogData: ObservableObject {
    let originalRows: [RowDTO]
    var edits = LogEdits()
    
    init(rows: [RowDTO]) {
        self.originalRows = rows
    }
    
    func getFieldName(key: String) -> String {
        if let editedName = edits.headerEdits[key] {
            return editedName
        }
        return originalRows.first(where: { $0.header })?.content[key] ?? key
    }
    
    func getValue(rowIndex: Int, key: String) -> String {
        if let rowEdits = edits.contentEdits[rowIndex],
           let editedValue = rowEdits[key] {
            return editedValue
        }
        return originalRows.first(where: { $0.rowIndex == rowIndex && !$0.header })?
            .content[key] ?? ""
    }
    
    func updateFieldName(oldKey: String, newName: String) {
        print("Updating header field \(oldKey) to \(newName)")
        if edits.headerEdits[oldKey] != newName {
            edits.headerEdits[oldKey] = newName
        }
    }
    
    func updateValue(rowIndex: Int, key: String, newValue: String) {
        print("Updating row \(rowIndex) field \(key) to \(newValue)")
        let originalValue = originalRows
            .first(where: { $0.rowIndex == rowIndex && !$0.header })?
            .content[key] ?? ""
        if originalValue != newValue {
            if edits.contentEdits[rowIndex] == nil {
                edits.contentEdits[rowIndex] = [:]
            }
            edits.contentEdits[rowIndex]?[key] = newValue
        } else {
            edits.contentEdits[rowIndex]?[key] = nil
            if let rowEdits = edits.contentEdits[rowIndex], rowEdits.isEmpty {
                edits.contentEdits.removeValue(forKey: rowIndex)
            }
        }
        print("Content edits after update: \(edits.contentEdits)")
    }
    
    func getEditedRows() -> [RowDTO] {
        print("Getting edited rows")
        print("Content edits: \(edits.contentEdits)")
        print("Header edits: \(edits.headerEdits)")
        
        var updatedHeaderContent: [String: String] = [:]
        if let headerRow = originalRows.first(where: { $0.header }) {
            updatedHeaderContent = headerRow.content
            
            for (key, editedName) in edits.headerEdits {
                if updatedHeaderContent[key] != nil {
                    updatedHeaderContent[key] = editedName
                }
            }
        }
        
        let updatedHeaderRow = RowDTO(
            rowIndex: 0,
            content: updatedHeaderContent,
            header: true
        )
        
        var result: [RowDTO] = [updatedHeaderRow]
        
        for row in originalRows.filter({ !$0.header }) {
            let rowIndex = row.rowIndex
            
            var updatedContent = row.content
            
            if let rowEdits = edits.contentEdits[rowIndex] {
                for (key, value) in rowEdits {
                    updatedContent[key] = value
                }
            }
            
            let updatedRow = RowDTO(
                rowIndex: rowIndex,
                content: updatedContent,
                header: false
            )
            
            result.append(updatedRow)
        }
        
        return result
    }
}
