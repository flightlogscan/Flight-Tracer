import SwiftUI

class EditableLog: ObservableObject {
    var editableRows: [EditableRow]
    var imageData: Data?

    init(editableRows: [EditableRow], imageData: Data? = nil) {
        self.editableRows = editableRows
        self.imageData = imageData
    }
}
