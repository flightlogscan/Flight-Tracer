import Foundation
import SwiftData

class StoredLogsDao {
    private let modelContext: ModelContext
    private let userId: String

    init(modelContext: ModelContext, userId: String) {
        self.modelContext = modelContext
        self.userId = userId
    }

    public func getStoredLogs() -> [StoredLog] {
        let uid = userId
        let descriptor = FetchDescriptor<StoredLog>(
            predicate: #Predicate { $0.userId == uid },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )

        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch logs: \(error)")
            return []
        }
    }
    
    public func getStoredLog(by id: PersistentIdentifier) -> StoredLog? {
        modelContext.model(for: id) as? StoredLog
    }
}

