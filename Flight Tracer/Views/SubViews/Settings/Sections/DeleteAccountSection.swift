import SwiftUI

struct DeleteAccountSection: View {
    @EnvironmentObject var authManager: AuthManager

    @State private var showAlert = false

    var body: some View {
        Section ("Highway to the Danger Zone"){
            Button(action: { showAlert = true }) {
                HStack {
                    Spacer()
                    Text("Delete Account")
                        .foregroundColor(.red)
                        .fontWeight(.semibold)
                    Spacer()
                }
            }
            .listRowBackground(Color.red.opacity(0.05))
            .alert("Delete Account?", isPresented: $showAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    // Need to make + call backend delete account API
                }
            } message: {
                Text("Deleting this account will remove your data from this device. Data stored in iCloud will not be deleted.")
            }
            .accessibilityIdentifier("DeleteAccountButton")
        }
    }
}
