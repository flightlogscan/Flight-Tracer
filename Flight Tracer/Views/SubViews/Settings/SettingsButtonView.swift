import SwiftUI

struct SettingsButtonView: View {
    @Binding var selectedScanType: ScanType
    @State var showSettingsSheet: Bool = false

    var body: some View {
        Button {
            let _ = print("SettingsButtonPressed willy")
            showSettingsSheet = true
        } label: {
            Image(systemName: "gearshape.fill")
                .frame(width: 36, height: 36)
                .foregroundColor(.semiTransparentBlack)
                .background(
                    Circle()
                        .fill(.thickMaterial)
                        .environment(\.colorScheme, .light)
                )
        }
        .sheet(isPresented: $showSettingsSheet) {
            SettingsSheet(showSettingsSheet: $showSettingsSheet, selectedScanType: $selectedScanType)
        }
        .accessibilityIdentifier("SettingsMenuButton")
    }
}

#Preview {
    AuthenticatedView()
}
