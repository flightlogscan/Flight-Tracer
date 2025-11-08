import SwiftUI

struct ScanButtonView: View {
    @EnvironmentObject var storeKitManager: StoreKitManager
    
    @Binding var scanPressed: Bool
    @Binding var isDisabled: Bool
    
    // Internal state to manage presentation
    @State private var internalShowStore = false

    var body: some View {
        VStack {
            Button("Scan", role: .confirm) {
                if storeKitManager.isSubscribed() {
                    scanPressed = true
                } else {
                    scanPressed = false
                    internalShowStore = true
                }
            }
            .accessibilityIdentifier("ScanPhotoButton")
            .accessibilityLabel(Text("Scan photo button"))
            .disabled(isDisabled)
        }
        .premiumSheet(isPresented: $internalShowStore) {
            FLSStoreView()
        }
    }
}

#Preview {
    ScansView()
        .environmentObject(AuthManager())
        .environmentObject(StoreKitManager())

}
