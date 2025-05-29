import SwiftUI
import SwiftData

struct LogListView: View {
    @StateObject private var viewModel: LogListViewModel
    
    @State private var showDeleteConfirmation = false
    
    @Binding var showScanSheet: Bool

    let userId: String

    // Need init because view model needs model context
    init(userId: String, modelContext: ModelContext, showScanSheet: Binding<Bool>) {
        self.userId = userId
        self._showScanSheet = showScanSheet
        _viewModel = StateObject(wrappedValue: LogListViewModel(modelContext: modelContext, userId: userId))
    }
    
    var body: some View {
        ZStack {
            if viewModel.logSummaries.isEmpty {
                LogListPlaceHolderView()
            } else {
                LogListContent(
                    userId: userId,
                    summaries: viewModel.logSummaries,
                    viewModel: viewModel,
                    showScanSheet: $showScanSheet,
                    showDeleteConfirmation: $showDeleteConfirmation
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .onAppear() {
            viewModel.getLogSummaries()
        }
        .onChange(of: showScanSheet) { _, isPresented in
            if !isPresented {
                viewModel.getLogSummaries()
            }
        }
    }
}
