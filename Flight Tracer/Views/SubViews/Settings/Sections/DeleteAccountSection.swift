import SwiftUI

struct DeleteAccountSection: View {
    @EnvironmentObject var authManager: AuthManager

    @StateObject private var viewModel = DeleteAccountViewModel()
    @State private var showDeleteAccountConfirmation = false
    @State private var showDeleteAccountAlert = false
    @State private var resultMessage = ""
    
    let selectedScanType: ScanType

    var body: some View {
        Section ("Highway to the Danger Zone"){
            Button(action: { showDeleteAccountConfirmation = true }) {
                HStack {
                    Spacer()
                    Text("Delete Account")
                        .foregroundColor(.red)
                        .fontWeight(.semibold)
                    Spacer()
                }
            }
            .listRowBackground(Color.red.opacity(0.05))
            .alert("Delete Account?", isPresented: $showDeleteAccountConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    Task {
                        await viewModel.deleteAccount(token: authManager.user.token, selectedScanType: selectedScanType)
                        
                        switch viewModel.deletionStatus {
                        case .success:
                            resultMessage = "Account deleted successfully"
                            showDeleteAccountAlert = true
                        case .failure, .none:
                            resultMessage = "Error deleting account. Please try again."
                            showDeleteAccountAlert = true
                        }
                    }
                }
            } message: {
                Text("Deleting this account will remove your data from this device. Data stored in iCloud will not be deleted.")
            }
            .alert(resultMessage, isPresented: $showDeleteAccountAlert) {
                Button("OK") {
                    if viewModel.deletionStatus == .success {
                        authManager.resetUser()
                    }
                }
            }
            .accessibilityIdentifier("DeleteAccountButton")
        }
    }
}
