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
            if viewModel.logs.isEmpty {
                let _ = print("empty logs")
                LogListPlaceHolderView()
            } else {
                let _ = print("logs \(viewModel.logs.count)")

                NavigationStack {
                    List(viewModel.logs) { log in
                        NavigationLink(log.title) {
                            Text("Detail for \(log.title)")
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .onAppear {
            viewModel.getLogs()
        }
    }
}
