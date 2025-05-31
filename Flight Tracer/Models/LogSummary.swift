import SwiftData
import Foundation
import SwiftUI
/**

 Use to lazy load logs from SwiftData.
 Keeps a refernece to Log Id and title for log list.
 Log list uses the id to load the full log when it's selected.
 
 */
struct LogSummary: Identifiable {
    let id: PersistentIdentifier
    let title: String
    let createdAt: Date
}
