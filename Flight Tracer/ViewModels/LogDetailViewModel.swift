import Foundation
import SwiftData

class LogDetailViewModel: ObservableObject {
    private let dao: StoredLogsDao
    //TODO: Needs to be optional/error handled if non-existant and DB fails to load
    @Published var log: EditableLog = EditableLog(editableRows: [])
    @Published var storedLog: StoredLog?

    init(modelContext: ModelContext, userId: String) {
        self.dao = StoredLogsDao(modelContext: modelContext, userId: userId)
    }

    func loadLog(id: PersistentIdentifier) {
        if let storedLog = dao.getStoredLog(by: id) {
            self.storedLog = storedLog
            let rows = storedLog.rows.map {
                EditableRow(
                    rowIndex: $0.rowIndex,
                    header: $0.header,
                    content: $0.content,
                    parentHeaders: $0.parentHeaders
                )
            }
            self.log = EditableLog(editableRows: rows, imageData: storedLog.imageData)
        }
    }
}
