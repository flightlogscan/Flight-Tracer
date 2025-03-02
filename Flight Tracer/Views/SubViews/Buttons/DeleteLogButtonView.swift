import SwiftUI

struct DeleteLogButtonView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var showAlert = false
    
    var body: some View {
        Button {
            showAlert = true
        } label: {
            Image(systemName: "xmark.circle.fill")
                .font(.title)
                .foregroundStyle(Color.primary, .ultraThinMaterial)
        }
        .accessibilityIdentifier("DeleteLog")
        .alert("Delete Log?", isPresented: $showAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                self.presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Deleting this log will delete its data, but any data stored in iCloud will not be deleted.")
        }
    }
}
