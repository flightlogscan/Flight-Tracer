import SwiftUI

struct SaveLogButtonView: View {
    
    @Environment(\.modelContext) private var modelContext
        
    let editableRows: [EditableRow]
    let userId: String
    
    var body: some View {
        Button {
            SaveLogButtonViewModel(modelContext: modelContext, userId: userId)
                .saveLog(editableRows: editableRows)
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
    }
}
