import SwiftUI
import SwiftData

struct LogListContent: View {
    let summaries: [LogSummary]
    let userId: String
    @Binding var showScanSheet: Bool
    @Binding var showDeleteConfirmation: Bool
    @Binding var logToDeleteID: PersistentIdentifier?
    let onDelete: (PersistentIdentifier) -> Void

    var body: some View {
        List {
            ForEach(summaries) { summary in
                LogListButtonView(logSummary: summary, userId: userId)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button {
                            logToDeleteID = summary.id
                            showDeleteConfirmation = true
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
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
                if let id = logToDeleteID {
                    onDelete(id)
                }
            }
            Button("Cancel", role: .cancel) {
            }
        }
    }
}
