import Foundation
import SwiftData

class LogListViewModel: ObservableObject {
    @Published var logSummaries: [LogSummary] = []

    private let dao: StoredLogsDao

    init(modelContext: ModelContext, userId: String) {
        self.dao = StoredLogsDao(modelContext: modelContext, userId: userId)
    }
    
    func getLogSummaries() {
        refreshSummaries()
    }

    func deleteLog(id: PersistentIdentifier) {
        dao.deleteLog(by: id)
        refreshSummaries()
    }
    
    private func refreshSummaries() {
        let storedLogs = dao.getStoredLogs()
        self.logSummaries = storedLogs.map {
            LogSummary(
                id: $0.persistentModelID,
                title: $0.title,
                createdAt: $0.createdAt
            )
        }
    }
}
