import Foundation

class EditableLogData: ObservableObject {
    let originalRows: [RowDTO]
    @Published var contentEdits: [Int: [String: String]] = [:]
    @Published var headerEdits: [String: String] = [:]
    
    init(rows: [RowDTO]) {
        self.originalRows = rows
    }
    
    func getFieldName(key: String) -> String {
        if let editedName = headerEdits[key] {
            return editedName
        }
        let headerRow = originalRows.first(where: { $0.header })
        return headerRow?.content[key] ?? key
    }
    
    func getValue(rowIndex: Int, key: String) -> String {
        if let rowEdits = contentEdits[rowIndex], let editedValue = rowEdits[key] {
            return editedValue
        }
        return originalRows.first(where: { $0.rowIndex == rowIndex && !$0.header })?.content[key] ?? ""
    }
    
    func updateFieldName(oldKey: String, newName: String) {
        headerEdits[oldKey] = newName
    }
    
    func updateValue(rowIndex: Int, key: String, newValue: String) {
        if contentEdits[rowIndex] == nil {
            contentEdits[rowIndex] = [:]
        }
        contentEdits[rowIndex]?[key] = newValue
    }
    
    func getEditedRows() -> [RowDTO] {
        var updatedHeaderContent: [String: String] = [:]
        if let headerRow = originalRows.first(where: { $0.header }) {
            updatedHeaderContent = headerRow.content
            
            for (key, editedName) in headerEdits {
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
            
            if let rowEdits = contentEdits[rowIndex] {
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
