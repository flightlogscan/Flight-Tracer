import SwiftUI

struct SubscriptionCoordinator: View {
    // Listen for subscription transactions at startup
    @StateObject private var storeKitManager = StoreKitManager()

    @Binding var selectedScanTye: ScanType

    var body: some View {
        ZStack {
            ScanView(selectedScanType: $selectedScanTye)
                .zIndex(1)
        }
        .environmentObject(storeKitManager)
    }
}
