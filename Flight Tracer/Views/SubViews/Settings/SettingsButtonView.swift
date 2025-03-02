import SwiftUI

struct SettingsButtonView: View {
    @Binding var selectedScanType: ScanType
    @State var isSheetPresented: Bool = false

    var body: some View {
        Button {
            isSheetPresented = true
        } label: {
            Image(systemName: "gearshape.fill")
                .frame( width: 36, height: 36)
                .foregroundColor(.semiTransparentBlack)
                .background(
                    Circle()
                        .fill(.thickMaterial)
                        .environment(\.colorScheme, .light)
                )
            
        }
        .sheet(isPresented: $isSheetPresented) {
            SettingsSheet(isSheetPresented: $isSheetPresented, selectedScanType: $selectedScanType)
        }
        .accessibilityIdentifier("SettingsMenuButton")
    }
}

#Preview {
    AuthenticatedView()
}
