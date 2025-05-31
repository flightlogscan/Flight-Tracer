import Foundation
import SwiftData

@Model
class StoredLogRow {
    var rowIndex: Int
    var header: Bool
    var content: [String: String]
    var parentHeaders: [String: String]?
    @Relationship var log: StoredLog?

    init(rowIndex: Int, header: Bool, content: [String: String], parentHeaders: [String: String]? = nil) {
        self.rowIndex = rowIndex
        self.header = header
        self.content = content
        self.parentHeaders = parentHeaders
    }
}

@Model
class StoredLog {
    var id: UUID
    var title: String
    var userId: String
    var createdAt: Date
    @Attribute(.externalStorage)
    var imageData: Data?
    @Relationship(deleteRule: .cascade) var rows: [StoredLogRow]

    init(title: String, userId: String, rows: [StoredLogRow] = [], imageData: Data? = nil) {
        self.id = UUID()
        self.title = title
        self.userId = userId
        self.createdAt = .now
        self.imageData = imageData
        self.rows = rows
    }
}
