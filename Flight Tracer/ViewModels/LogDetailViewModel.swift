import Foundation
import SwiftData

class LogDetailViewModel: ObservableObject {
    private let dao: StoredLogsDao
    @Published var log: [EditableRow] = []

    init(modelContext: ModelContext, userId: String) {
        self.dao = StoredLogsDao(modelContext: modelContext, userId: userId)
    }

    func loadLog(id: PersistentIdentifier) {
        if let storedLog = dao.getStoredLog(by: id) {
            self.log = storedLog.rows
                .map {
                    EditableRow(
                        rowIndex: $0.rowIndex,
                        header: $0.header,
                        content: $0.content,
                        parentHeaders: $0.parentHeaders
                    )
                }
        }
    }
}
