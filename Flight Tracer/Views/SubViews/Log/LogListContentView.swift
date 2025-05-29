import SwiftUI
import SwiftData

struct LogListContent: View {
    let userId: String
    let summaries: [LogSummary]
    let viewModel: LogListViewModel

    @State var selectedLogId: PersistentIdentifier?
    @Binding var showScanSheet: Bool
    @Binding var showDeleteConfirmation: Bool

    var body: some View {
        List {
            ForEach(summaries) { summary in
                LogListButtonView(logSummary: summary, userId: userId)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button {
                            selectedLogId = summary.id
                            showDeleteConfirmation = true
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
                        
                        if let shareItem = viewModel.exportLog(id: summary.id) {
                            ShareLink(item: shareItem, preview: SharePreview(summary.title)) {
                                Label("Export", systemImage: "square.and.arrow.up")
                            }
                            .tint(.blue)
                        }
                    }
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.navyBlue, .black, .black]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(.all)
        )
        .scrollContentBackground(.hidden)
        .scrollBounceBehavior(.basedOnSize)
        .toolbarBackground(.hidden, for: .navigationBar)
        .confirmationDialog(
            "This log will be deleted.",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                if let id = selectedLogId {
                    viewModel.deleteLog(id: id)
                }
            }
            Button("Cancel", role: .cancel) {
            }
        }
    }
}
