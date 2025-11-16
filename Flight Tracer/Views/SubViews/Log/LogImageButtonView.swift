import SwiftUI

struct LogImageButtonView: View {
    @Binding var showImageCover: Bool

    var body: some View {
        Button ("logimage", systemImage: "photo") {
            showImageCover = true
        }
        .accessibilityIdentifier("LogImageButton")
    }
}
