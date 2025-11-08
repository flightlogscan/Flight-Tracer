import SwiftUI

struct SettingsButtonView: View {
    @Binding var selectedScanType: ScanType
    @State var showSettingsSheet: Bool = false

    var body: some View {
        Button {
            showSettingsSheet = true
        } label: {
            Image(systemName: "gearshape")
                .font(.title3)
        }
        .sheet(isPresented: $showSettingsSheet) {
            SettingsSheet(showSettingsSheet: $showSettingsSheet, selectedScanType: $selectedScanType)
        }
        .accessibilityIdentifier("SettingsMenuButton")
        .tint(.white)
    }
}

#Preview {
    ScansView()
        .environmentObject(AuthManager())
        .environmentObject(StoreKitManager())

}
