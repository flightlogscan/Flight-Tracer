import SwiftUI
import SwiftData

struct LogListView: View {
    
    let userId: String
    @StateObject private var viewModel: LogListViewModel

    init(userId: String, modelContext: ModelContext) {
        self.userId = userId
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
    }
}
