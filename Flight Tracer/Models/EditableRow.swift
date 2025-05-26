import SwiftUI

class EditableRow: ObservableObject {
    let rowIndex: Int
    let header: Bool
    @Published var content: [String: String]
    let parentHeaders: [String: String]?
    
    init(rowIndex: Int, header: Bool, content: [String: String], parentHeaders: [String: String]? = nil) {
        self.rowIndex = rowIndex
        self.header = header
        self.content = content
        self.parentHeaders = parentHeaders
    }
}
