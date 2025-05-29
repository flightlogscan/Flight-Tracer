import SwiftUI

struct DismissScreenCoverButton: View {
    @Environment(\.dismiss) private var dismiss
        
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .font(.title)
                .foregroundStyle(Color.primary, .ultraThinMaterial)
        }
        .accessibilityIdentifier("DismissScreenCoverButton")
    }
}
