import SwiftUI
import FirebaseAuthUI

struct OptionsMenu: View {
    @Binding var selectedScanType: ScanType
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        Menu {
            Button {
                authViewModel.signOut()
            } label: {
                Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
            }
            
            if authViewModel.isAdmin() {
                Picker(selection: $selectedScanType, label: Label("Options", systemImage: "gearshape")) {
                    ForEach(ScanType.allCases) { option in
                        Text(option.displayName).tag(option)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
        } label: {
            Label("", systemImage: "gearshape")
        }
    }
}
