import SwiftUI
import SwiftData

struct LogDetailView: View {
    @EnvironmentObject private var authManager: AuthManager
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel: LogDetailViewModel
    @State private var showImageCover: Bool = false
    
    //TODO: Needs to be optional/error handled if non-existant
    @State var editableLog: EditableLog = EditableLog(editableRows: [])

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
                    LogTabsView(editableLog: $editableLog)
                    
                }
                .onAppear {
                    viewModel.loadLog(id: logSummary.id)
                    editableLog = viewModel.log
                }
                .toolbar {
                    ToolbarItemGroup(placement: .topBarLeading) {
                        DismissScreenCoverButton()
                    }
                    
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        if let storedLog = viewModel.storedLog {
                            HStack(spacing: 0) {
                                LogImageButtonView(showImageCover: $showImageCover)
                                    .fullScreenCover(isPresented: $showImageCover) {
                                        LogImageSheetCoverView(imageData: editableLog.imageData)
                                    }
                                
                                SaveLogButtonView(
                                    userId: userId,
                                    modelContext: modelContext,
                                    editableLog: editableLog,
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
}
