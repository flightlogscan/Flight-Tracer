import Foundation

// Make this a struct instead of a class for value semantics
struct LogEdits {
    var contentEdits: [Int: [String: String]] = [:]
    var headerEdits: [String: String] = [:]
    
    // Helper to check if we have any edits
    var hasEdits: Bool {
        return !contentEdits.isEmpty || !headerEdits.isEmpty
    }
}

class EditableLogData: ObservableObject {
    let originalRows: [RowDTO]
    @Published var edits = LogEdits()
    
    init(rows: [RowDTO]) {
        self.originalRows = rows
    }
    
    func getFieldName(key: String) -> String {
        if let editedName = edits.headerEdits[key] {
            return editedName
        }
        let headerRow = originalRows.first(where: { $0.header })
        return headerRow?.content[key] ?? key
    }
    
    func getValue(rowIndex: Int, key: String) -> String {
        if let rowEdits = edits.contentEdits[rowIndex], let editedValue = rowEdits[key] {
            return editedValue
        }
        return originalRows.first(where: { $0.rowIndex == rowIndex && !$0.header })?.content[key] ?? ""
    }
    
    func updateFieldName(oldKey: String, newName: String) {
        print("Updating header field \(oldKey) to \(newName)")
        
        // Only update if the name is actually different
        let currentName = getFieldName(key: oldKey)
        if currentName != newName {
            // Create a new copy of headerEdits with the update
            var newHeaderEdits = edits.headerEdits
            newHeaderEdits[oldKey] = newName
            
            // Replace the entire edits struct with a new one
            var newEdits = edits
            newEdits.headerEdits = newHeaderEdits
            edits = newEdits
        }
    }
    
    func updateValue(rowIndex: Int, key: String, newValue: String) {
        print("Updating row \(rowIndex) field \(key) to \(newValue)")
        
        // Get the original value for comparison
        let originalValue = originalRows.first(where: { $0.rowIndex == rowIndex && !$0.header })?.content[key] ?? ""
        
        // Create a new copy of our edits
        var newEdits = edits
        
        // Only update if the value has actually changed from the original
        if originalValue != newValue {
            if newEdits.contentEdits[rowIndex] == nil {
                newEdits.contentEdits[rowIndex] = [:]
            }
            newEdits.contentEdits[rowIndex]?[key] = newValue
        } else {
            // If setting back to original value, remove the edit
            if newEdits.contentEdits[rowIndex]?[key] != nil {
                newEdits.contentEdits[rowIndex]?[key] = nil
                
                // Clean up empty dictionaries
                if newEdits.contentEdits[rowIndex]?.isEmpty ?? true {
                    newEdits.contentEdits.removeValue(forKey: rowIndex)
                }
            }
        }
        
        // Replace the entire edits struct with our new version
        edits = newEdits
        
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
