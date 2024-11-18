import SwiftUI

struct ScanView: View {

    @State var scanButtonActive: Bool = false
    @Binding var activeScanPressed: Bool
    @Binding var selectedImage: ImageDetail
    
    var body: some View {
        VStack{
            Button {
                activeScanPressed = scanButtonActive
            } label: {
                Label("Scan photo", systemImage: "doc.viewfinder.fill")
                    .frame(maxWidth: .infinity)
                    .font(.title2)
                    .padding()
            }
            .onAppear() {
                scanButtonActive = (selectedImage.isImageValid == true && selectedImage.isValidated == true)
            }
            .buttonStyle(.borderedProminent)
            .tint(scanButtonActive ? .green : .gray.opacity(0.5))
            .shadow(color: scanButtonActive ? .gray : .clear, radius: scanButtonActive ? 5 : 0)
            .bold()
            .padding([.leading, .trailing, .bottom])
            .accessibilityLabel(Text("Scan photo button"))
            .accessibilityHint(Text(scanButtonActive ? "Tap to start scanning" : "Button is disabled"))
        }
        .onReceive(selectedImage.$isImageValid) {_ in
            if (selectedImage.isImageValid != nil) {
                scanButtonActive = selectedImage.isImageValid! && selectedImage.isValidated == true
            } else {
                scanButtonActive = false
            }
        }
    }
}
