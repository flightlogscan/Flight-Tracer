import SwiftUI

class LogTabViewModel: ObservableObject {
    var editableLogData: EditableLogData?

    func setEditableData(from rows: [RowDTO]) {
        self.editableLogData = EditableLogData(rows: rows)
    }
    
    func updateField(rowIndex: Int, fieldKey: String, newValue: String) {
        print("LogSwiperViewModel.updateField called")
        print("Row: \(rowIndex), Field: \(fieldKey), New Value: \(newValue)")
        
        editableLogData?.updateValue(rowIndex: rowIndex, key: fieldKey, newValue: newValue)
    }
    
    func updateFieldName(oldKey: String, newName: String) {
        print("LogSwiperViewModel.updateFieldName called")
        print("Old Key: \(oldKey), New Name: \(newName)")
        
        editableLogData?.updateFieldName(oldKey: oldKey, newName: newName)
    }
}
