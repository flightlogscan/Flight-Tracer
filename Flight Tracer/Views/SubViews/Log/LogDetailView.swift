import SwiftUI
import SwiftData

struct LogDetailView: View {
    @EnvironmentObject private var authManager: AuthManager
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel: LogDetailViewModel
    @State var editableRows: [EditableRow] = []

    private let userId: String
    private let logSummary: LogSummary
    private let modelContext: ModelContext

    // Had to do init cause the ViewModel needs the modelContext
    init(logSummary: LogSummary, modelContext: ModelContext, userId: String) {
        self.userId = userId
        self.logSummary = logSummary
        self.modelContext = modelContext
        _viewModel = StateObject(wrappedValue: LogDetailViewModel(modelContext: modelContext, userId: userId))
    }

    var body: some View {
        NavigationStack {
            ZStack (alignment: .top) {
                Rectangle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.navyBlue, .black, .black]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .ignoresSafeArea(.all)
                VStack {
                    LogTabsView(editableRows: $editableRows)
                }
                .onAppear {
                    viewModel.loadLog(id: logSummary.id)
                    editableRows = viewModel.log
                }
                .toolbar {
                    ToolbarItemGroup(placement: .topBarLeading) {
                        DismissScreenCoverButton()
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        if let storedLog = viewModel.storedLog {
                            SaveLogButtonView(
                                userId: userId,
                                modelContext: modelContext,
                                editableRows: editableRows,
                                logSaveMode: .edit(existing: storedLog)
                            ) {
                                dismiss()
                            }
                        }
                    }
                }
            }
        }
    }
}
