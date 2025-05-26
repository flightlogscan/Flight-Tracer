import SwiftUI
import SwiftData

struct SaveLogButtonView: View {
    
    let editableRows: [EditableRow]
    let userId: String
    let onComplete: () -> Void
    
    @StateObject private var viewModel: SaveLogButtonViewModel
    
    init(userId: String, modelContext: ModelContext, editableRows: [EditableRow], onComplete: @escaping () -> Void) {
        self.userId = userId
        self.editableRows = editableRows
        self.onComplete = onComplete
        _viewModel = StateObject(wrappedValue: SaveLogButtonViewModel(modelContext: modelContext, userId: userId))
    }

    
    var body: some View {
        Button {
            viewModel.saveLog(editableRows: editableRows)
        } label: {
            Text("Save")
                .font(.headline)
                .padding(.horizontal, 15)
                .padding(.vertical, 7.5)
                .foregroundColor(.black)
                .background(.thickMaterial)
                .environment(\.colorScheme, .light)
                .clipShape(Capsule())
        }
        .accessibilityIdentifier("SaveButton")
        .onChange(of: viewModel.logSaved) { _, newValue in
            if newValue {
                print("here")
                onComplete()
            }
        }
    }
}
