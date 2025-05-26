import Foundation
import SwiftData

class SaveLogButtonViewModel: ObservableObject {
    private let modelContext: ModelContext
    private let userId: String

    init(modelContext: ModelContext, userId: String) {
        self.modelContext = modelContext
        self.userId = userId
    }

    func saveLog(editableRows: [EditableRow]) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestamp = formatter.string(from: Date())

        let storedRows = editableRows.map { editable in
            StoredLogRow(
                rowIndex: editable.rowIndex,
                header: editable.header,
                content: editable.content,
                parentHeaders: editable.parentHeaders
            )
        }

        let newLog = StoredLog(title: "Log \(timestamp)", userId: userId, rows: storedRows)
        for row in storedRows {
            row.log = newLog
        }

        modelContext.insert(newLog)

        do {
            try modelContext.save()
            print("Saved log successfully!")
        } catch {
            print("Failed to save log: \(error)")
        }
    }
}
