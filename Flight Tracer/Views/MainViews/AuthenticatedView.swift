import SwiftUI
import FirebaseAuthUI
import PhotosUI

struct AuthenticatedView: View {
    @State var selectedScanType: ScanType = .api
         
    var body: some View {
        NavigationStack {
            ZStack {
                SubscriptionCoordinator(selectedScanTye: $selectedScanType)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Flight Log Scan")
                        .font(.custom(
                            "Magnolia Script",
                            fixedSize: 24))
                        .foregroundStyle(.white)
                        .accessibilityIdentifier("ToolbarTitle")
                }
                ToolbarItem(placement: .primaryAction) {
                    SettingsButtonView(selectedScanType: $selectedScanType)
                        .accessibilityIdentifier("OptionsMenu")
                }
            }
            .tint(.white)
            .toolbarBackground(
                Color.navyBlue,
                for: .navigationBar
            )
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}
