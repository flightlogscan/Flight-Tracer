import SwiftUI
import SwiftData

struct SaveLogButtonView: View {
    let editableLog: EditableLog
    let userId: String
    let onComplete: () -> Void
    let logSaveMode: LogSaveMode

    @StateObject private var viewModel: SaveLogButtonViewModel

    // Had to do init cause the ViewModel needs the modelContext
    init(userId: String, modelContext: ModelContext, editableLog: EditableLog, logSaveMode: LogSaveMode, onComplete: @escaping () -> Void) {
        self.userId = userId
        self.editableLog = editableLog
        self.onComplete = onComplete
        self.logSaveMode = logSaveMode
        _viewModel = StateObject(wrappedValue: SaveLogButtonViewModel(modelContext: modelContext, userId: userId))
    }

    var body: some View {
        Button {
            viewModel.saveLog(editableLog: editableLog, logSaveMode: logSaveMode)
        } label: {
            Text("Save")
                .font(.headline)
                .padding(.horizontal, 15)
                .padding(.vertical, 7.5)
                .foregroundColor(.black)
                .background(.regularMaterial)
                .environment(\.colorScheme, .light)
                .clipShape(Capsule())
        }
        .accessibilityIdentifier("SaveButton")
        .onChange(of: viewModel.logSaved) { _, newValue in
            if newValue {
                onComplete()
            }
        }
    }
}
