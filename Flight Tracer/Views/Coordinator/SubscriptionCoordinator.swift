import SwiftUI

struct SubscriptionCoordinator: View {
    // Listen for subscription transactions at startup
    @StateObject private var storeKitManager = StoreKitManager()

    @Binding var selectedScanTye: ScanType

    var body: some View {
        if !storeKitManager.finishedCheckingSubscriptionStatus {
            ZStack {
                Color.black
                    .opacity(0.5)
                    .ignoresSafeArea()
                    .zIndex(1)
                
                ProgressView()
                    .tint(.white)
                    .padding()
                    .background(.black)
                    .cornerRadius(10)
                    .zIndex(1)
                
                ScanView(selectedScanType: $selectedScanTye)
                    .allowsHitTesting(false)
            }
        } else if storeKitManager.isSubscribed() {
            ScanView(selectedScanType: $selectedScanTye)
                .zIndex(1)
        } else if !storeKitManager.isSubscribed() {
            ZStack {
                Color.black
                    .opacity(0.5)
                    .ignoresSafeArea()
                    .zIndex(1)
                
                SubscriptionPopup()
                    .zIndex(1)
                
                ScanView(selectedScanType: $selectedScanTye)
                    .allowsHitTesting(false)
            }
        }
    }
}
