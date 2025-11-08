import SwiftUI

struct SettingsButtonView: View {
    @Binding var selectedScanType: ScanType
    @State var showSettingsSheet: Bool = false

    var body: some View {
        Button ("settings", systemImage: "gearshape") {
            showSettingsSheet = true
        }
        .sheet(isPresented: $showSettingsSheet) {
            SettingsSheet(showSettingsSheet: $showSettingsSheet, selectedScanType: $selectedScanType)
        }
        .accessibilityIdentifier("SettingsMenuButton")
    }
}

#Preview {
    ScansView()
        .environmentObject(AuthManager())
        .environmentObject(StoreKitManager())

}
