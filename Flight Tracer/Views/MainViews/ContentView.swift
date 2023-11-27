import SwiftUI

struct ContentView: View {
    @State var user: User?

    var body: some View {
        if (user == nil) {
            LoginView(user: $user)
        } else {
            FlightLogUploadView(user: $user)
        }
    }
}

struct l_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

