import SwiftUI

struct LogListButtonView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var showDetailSheet = false
    
    let logSummary: LogSummary
    let userId: String

    var body: some View {
        Button(logSummary.title) {
            showDetailSheet = true
        }
        .buttonStyle(PlainButtonStyle())
        .fullScreenCover(isPresented: $showDetailSheet) {
            LogDetailView(logSummary: logSummary, modelContext: modelContext, userId: userId)
        }
    }
}
