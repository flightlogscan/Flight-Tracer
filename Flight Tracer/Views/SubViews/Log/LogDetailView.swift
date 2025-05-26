import SwiftUI
import SwiftData

struct LogDetailView: View {
    let userId: String
    let logSummary: LogSummary
    
    @State var editableRows: [EditableRow] = []

    @EnvironmentObject private var authManager: AuthManager
    @StateObject private var viewModel: LogDetailViewModel

    init(logSummary: LogSummary, modelContext: ModelContext, userId: String) {
        self.userId = userId
        self.logSummary = logSummary
        _viewModel = StateObject(wrappedValue: LogDetailViewModel(modelContext: modelContext, userId: userId))
    }

    var body: some View {
        VStack {
            LogTabsView(editableRows: $editableRows)
        }
        .padding()
        .onAppear {
            viewModel.loadLog(id: logSummary.id)
            editableRows = viewModel.log
        }
    }
}
