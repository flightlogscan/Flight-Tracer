import SwiftUI

struct ScanButtonView: View {
    
    @State var scanButtonActive: Bool = false
    
    @Binding var activeScanPressed: Bool
    @Binding var isImageValid: Bool
    
    var body: some View {
        VStack{
            Button {
                activeScanPressed = scanButtonActive
            } label: {
                Label("Scan log", systemImage: "doc.viewfinder.fill")
                    .frame(maxWidth: .infinity)
                    .font(.title2)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
            .bold()
            .padding([.leading, .trailing, .bottom])
            .disabled(!scanButtonActive)
            .accessibilityIdentifier("ScanPhotoButton")
            .accessibilityLabel(Text("Scan photo button"))
            .accessibilityHint(Text(scanButtonActive ? "Tap to start scanning" : "Button is disabled"))
        }
        .onChange(of: isImageValid) {
            scanButtonActive = isImageValid
        }
    }
}
