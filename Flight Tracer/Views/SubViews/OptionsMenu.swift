import SwiftUI
import FirebaseAuthUI

struct OptionsMenu: View {
    @Binding var selectedOption: Int
    @Binding var user: User?
    let authUI = FUIAuth.defaultAuthUI()


    var body: some View {
        Menu {
            Button {
                user = nil
                do {
                    try self.authUI?.signOut()
                } catch let error {
                    print("error: \(error)")
                }
            } label: {
                Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
            }
            
            if user?.email == "flightlogtracer@gmail.com" {
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
