import SwiftUI

struct DismissScreenCoverButton: View {
    @Environment(\.dismiss) private var dismiss
        
    var body: some View {
        Button(role: .cancel) {
            dismiss()
        }
        .accessibilityIdentifier("DismissScreenCoverButton")
    }
}

#Preview {
    ScansView()
        .environmentObject(AuthManager())
        .environmentObject(StoreKitManager())
}
