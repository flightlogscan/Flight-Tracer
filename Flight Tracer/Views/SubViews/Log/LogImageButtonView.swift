import SwiftUI

struct LogImageButtonView: View {
    @Binding var showImageCover: Bool
    
    var body: some View {
        Button {
            showImageCover = true
        } label: {
            Image(systemName: "photo.circle.fill")
                .font(.title)
                .foregroundStyle(.regularMaterial)
        }
        .environment(\.colorScheme, .light)
    }
}
