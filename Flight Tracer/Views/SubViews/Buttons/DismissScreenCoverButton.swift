import SwiftUI

struct DismissScreenCoverButton: View {
    @Environment(\.dismiss) private var dismiss
        
    var body: some View {
        Button("Cancel", systemImage: "xmark") {
            dismiss()
        }
        .accessibilityIdentifier("DismissScreenCoverButton")
    }
}
