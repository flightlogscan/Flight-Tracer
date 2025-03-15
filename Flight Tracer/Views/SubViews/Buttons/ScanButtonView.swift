import SwiftUI

struct ScanButtonView: View {
    
    @State var scanButtonActive: Bool = false
    
    @Binding var activeScanPressed: Bool

    var body: some View {
        VStack{
            Button {
                activeScanPressed = true
            } label: {
                Text("Scan")
                    .font(.headline)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 7.5)
                    .foregroundColor(.white)
            }
            .background(.green)
            .clipShape(Capsule())
            .accessibilityIdentifier("ScanPhotoButton")
            .accessibilityLabel(Text("Scan photo button"))
            .accessibilityHint(Text(scanButtonActive ? "Tap to start scanning" : "Button is disabled"))
        }
        .offset(x: -25, y: 5)
    }
}

#Preview {
    AuthenticatedView()
}
