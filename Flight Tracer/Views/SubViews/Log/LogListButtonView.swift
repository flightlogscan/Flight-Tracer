import SwiftUI

struct LogListButtonView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var showingSheet = false
    
    let logSummary: LogSummary
    let userId: String


    var body: some View {
        Button(logSummary.title) {
            showingSheet = true
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingSheet) {
            LogDetailView(logSummary: logSummary, modelContext: modelContext, userId: userId)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
                .presentationBackground(.regularMaterial)

        }
    }
}
