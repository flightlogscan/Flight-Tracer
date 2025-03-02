import SwiftUI

struct PillButtonView: View {
    @Binding var selectedImage: ImageDetail
    
    var body: some View {
        HStack(spacing: 0) {
            CameraView(selectedImage: $selectedImage)
            
            Rectangle()
                .fill(Color.secondary)
                .frame(width: 1, height: 28)
                .padding(.vertical, 6)

            PhotoPickerView(selectedImage: $selectedImage)
        }
        .background(.thickMaterial)
        .environment(\.colorScheme, .light)
        .clipShape(Capsule())
    }
}

#Preview {
    AuthenticatedView()
}
