import SwiftUI
import SwiftData

struct LogListView: View {
    @StateObject private var viewModel: LogListViewModel
    @Binding var showScanSheet: Bool

    let userId: String

    // Need init because view model needs model context
    init(userId: String, modelContext: ModelContext, showScanSheet: Binding<Bool>) {
        self.userId = userId
        self._showScanSheet = showScanSheet
        _viewModel = StateObject(wrappedValue: LogListViewModel(modelContext: modelContext, userId: userId))
    }
    
    var body: some View {
        Group {
            if viewModel.logSummaries.isEmpty {
                LogListPlaceHolderView()
            } else {
                NavigationStack {
                    ZStack {
                        Rectangle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [.navyBlue, .black, .black]),
                                startPoint: .top,
                                endPoint: .bottom
                            ))
                            .ignoresSafeArea(.all)
                        List(viewModel.logSummaries) { logSummary in
                            LogListButtonView(logSummary: logSummary, userId: userId)
                        }
                        .scrollContentBackground(.hidden)
                        .scrollBounceBehavior(.basedOnSize)
                        .listRowBackground(Color.clear)
                    }
                    .toolbarBackground(.hidden, for: .navigationBar)
                }
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
