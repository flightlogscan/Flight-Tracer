import SwiftUI
import FirebaseAuthUI

struct SettingsButtonView: View {
    @Binding var selectedScanType: ScanType
    @State var isSheetPresented: Bool = false

    var body: some View {
        Button {
            isSheetPresented = true
        } label: {
            Image(systemName: "gearshape")
                .foregroundStyle(.white)
        }
        .sheet(isPresented: $isSheetPresented) {
            SettingsSheet(isSheetPresented: $isSheetPresented, selectedScanType: $selectedScanType)
        }
        .accessibilityIdentifier("SettingsMenuButton")
    }
}
