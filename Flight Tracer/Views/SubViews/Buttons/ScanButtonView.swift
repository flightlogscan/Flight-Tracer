import SwiftUI

struct ScanButtonView: View {
    @EnvironmentObject var storeKitManager: StoreKitManager
    
    @Binding var scanPressed: Bool
    
    // Internal state to manage presentation
    @State private var internalShowStore = false

    var body: some View {
        VStack{
            Button {
                if storeKitManager.isSubscribed() {
                    scanPressed = true
                } else {
                    scanPressed = false
                    internalShowStore = true
                }
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
        }
        .offset(x: -25, y: 5)
        .premiumSheet(isPresented: $internalShowStore) {
            FLSStoreView()
        }
    }
}

#Preview {
    AuthenticatedView()
}
