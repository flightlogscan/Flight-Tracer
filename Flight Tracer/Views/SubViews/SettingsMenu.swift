import SwiftUI
import FirebaseAuthUI

struct SettingsMenu: View {
    @Binding var selectedScanType: ScanType
    @State var isSheetPresented: Bool = false

    var body: some View {
        Button {
            isSheetPresented = true
        } label: {
            Label("", systemImage: "gearshape")
        }
        .sheet(isPresented: $isSheetPresented) {
            SettingsSheet(isSheetPresented: $isSheetPresented, selectedScanType: $selectedScanType)
        }
        .accessibilityIdentifier("SettingsMenuButton")
    }
}
