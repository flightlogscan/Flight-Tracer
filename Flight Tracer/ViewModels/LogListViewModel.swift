import Foundation
import SwiftData

class LogListViewModel: ObservableObject {
    private let dao: StoredLogsDao
    @Published var logSummaries: [LogSummary] = []

    init(modelContext: ModelContext, userId: String) {
        self.dao = StoredLogsDao(modelContext: modelContext, userId: userId)
    }
    
    func getLogSummaries() {
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
