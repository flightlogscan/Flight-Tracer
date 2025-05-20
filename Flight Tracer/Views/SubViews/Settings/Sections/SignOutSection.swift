import SwiftUI

struct SignOutSection: View {
    @EnvironmentObject var authManager: AuthManager
    
    @State var showAlert = false
    
    @Binding var selectedScanType: ScanType

    var body: some View {
        Section {
            Button(action: { showAlert = true }) {
                HStack {
                    Spacer()
                    Text("Sign Out")
                        .foregroundColor(.red)
                        .fontWeight(.semibold)
                    Spacer()
                }
            }
            .listRowBackground(Color.gray.opacity(0.2))
            .alert("Sign Out?", isPresented: $showAlert) {
                Button("Cancel", role: .cancel) { }
                
                Button("Sign Out", role: .destructive) {
                    authManager.signOut()
                }
            } message: {
                Text("Any files not yet saved will be lost if you sign out. Are you sure you want to sign out?")
            }
            .accessibilityIdentifier("SignOutButton")
        }
    }
}
