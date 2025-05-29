import Foundation
import SwiftData

class SaveLogButtonViewModel: ObservableObject {
    private let modelContext: ModelContext
    private let userId: String
    private let storedLogDao: StoredLogsDao

    @Published var logSaved = false
    
    init(modelContext: ModelContext, userId: String) {
        self.modelContext = modelContext
        self.userId = userId
        self.storedLogDao = StoredLogsDao(modelContext: modelContext, userId: userId)
    }

    func saveLog(editableRows: [EditableRow], logSaveMode: LogSaveMode) {
        switch logSaveMode {
        case .new:
            handleNewLog(from: editableRows)
        case .edit(let storedLog):
            handleEditLog(existing: storedLog, from: editableRows)
        }
        
        logSaved = true
    }

    private func handleNewLog(from editableRows: [EditableRow]) {
        let storedRows = editableRows.map { editable in
            StoredLogRow(
                rowIndex: editable.rowIndex,
                header: editable.header,
                content: editable.content,
                parentHeaders: editable.parentHeaders
            )
        }

        let newLog = StoredLog(title: makeLogTitle(), userId: userId, rows: storedRows)
        for row in storedRows {
            row.log = newLog
        }

        storedLogDao.insertLog(newLog)
    }

    private func handleEditLog(existing storedLog: StoredLog, from editableRows: [EditableRow]) {
        let updatedRows = editableRows
            .sorted(by: { $0.rowIndex < $1.rowIndex })
            .map { editable in
                StoredLogRow(
                    rowIndex: editable.rowIndex,
                    header: editable.header,
                    content: editable.content,
                    parentHeaders: editable.parentHeaders
                )
            }

        storedLog.rows = updatedRows
        for row in updatedRows {
            row.log = storedLog
        }

        storedLogDao.updateLog()
    }
    
    private func makeLogTitle() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let timestamp = formatter.string(from: Date())
        return "Log \(timestamp)"
    }
}
