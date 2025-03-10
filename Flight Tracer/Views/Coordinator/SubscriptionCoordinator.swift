import SwiftUI

struct SubscriptionCoordinator: View {

    @Binding var selectedScanTye: ScanType

    var body: some View {
        ZStack {
            ScanView(selectedScanType: $selectedScanTye)
                .zIndex(1)
        }
    }
}
