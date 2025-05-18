import SwiftUI

struct SettingsButtonView: View {
    @Binding var selectedScanType: ScanType
    @State var showSettingsSheet: Bool = false

    var body: some View {
        Button {
            showSettingsSheet = true
        } label: {
            Image(systemName: "gearshape.circle.fill")
                .font(.title)
                .foregroundStyle(.thickMaterial)
        }
        .environment(\.colorScheme, .light)
        .sheet(isPresented: $showSettingsSheet) {
            SettingsSheet(showSettingsSheet: $showSettingsSheet, selectedScanType: $selectedScanType)
        }
        .accessibilityIdentifier("SettingsMenuButton")
    }
}

#Preview {
    AuthenticatedView()
}
