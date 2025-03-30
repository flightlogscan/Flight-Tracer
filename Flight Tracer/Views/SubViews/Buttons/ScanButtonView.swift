import SwiftUI

struct ScanButtonView: View {
    @EnvironmentObject var storeKitManager: StoreKitManager
    
    // @AppStorage links this variable directly to UserDefaults.
    // "freeScansRemaining" is the key used in UserDefaults.
    // The value 10 is the default *only if* no value exists yet for the key.
    // Any changes to 'counter' are automatically saved to UserDefaults.
    @AppStorage("freeScansRemaining") var counter: Int = 0
    @Binding var scanPressed: Bool
    @Binding var showStore: Bool
    
    // Internal state to manage presentation
    @State private var internalShowStore = false

    var body: some View {
        VStack{
            Button {
                if storeKitManager.isPremium() || counter > 0 {
                    decrementCounter()
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
        .sheet(isPresented: $internalShowStore) {
            FLSStoreView()
                .presentationDetents([.fraction(0.5)])
                .presentationCornerRadius(25)
        }
    }
    
    private func decrementCounter() {
        if counter > 0 {
            counter -= 1
            print("Counter decremented. New value: \(counter)")
        } else {
            scanPressed = false
            print("Counter is already at 0.")
        }
    }
}

#Preview {
    AuthenticatedView()
}
