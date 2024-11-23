import SwiftUI
import FirebaseAuthUI

struct OptionsMenu: View {
    @Binding var selectedOption: Int
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        Menu {
            Button {
                authViewModel.signOut()
            } label: {
                Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
            }
            
            if authViewModel.isAdmin() {
                Picker(selection: $selectedOption, label: Label("Options", systemImage: "gearshape")) {
                    Text("Localhost call").tag(0)
                    Text("Real API call").tag(1)
                    Text("Hardcoded data").tag(2)
                }
                .pickerStyle(MenuPickerStyle())
            }
        } label: {
            Label("", systemImage: "gearshape")
        }
    }
}
