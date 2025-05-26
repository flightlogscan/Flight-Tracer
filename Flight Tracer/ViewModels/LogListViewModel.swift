import Foundation
import SwiftData

class LogListViewModel: ObservableObject {
    private let modelContext: ModelContext
    private let userId: String
    @Published var logs: [StoredLog] = []

    init(modelContext: ModelContext, userId: String) {
        self.modelContext = modelContext
        self.userId = userId
    }
    
    func getLogs() {
        let uid = userId
        let descriptor = FetchDescriptor<StoredLog>(
            predicate: #Predicate { $0.userId == uid },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )

        do {
            let results = try modelContext.fetch(descriptor)
            self.logs = results
        } catch {
            print("Failed to fetch logs: \(error)")
        }
    }
    
}
