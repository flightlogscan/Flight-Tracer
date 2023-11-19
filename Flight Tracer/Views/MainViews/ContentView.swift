import SwiftUI
import Auth0

struct ContentView: View {
    @State var user: User?

    var body: some View {
        if self.user != nil {
            VStack {
                FlightLogUploadView(user: $user)
            }
        } else {
            VStack {
                Button("Login", action: self.login)
            }
        }
    }
}

extension ContentView {
    func login() {
        Auth0
            .webAuth()
            .useEphemeralSession()
            .parameters(["prompt": "login"]) // Ignore the cookie (if present) and show the login page
            .start { result in
                switch result {
                case .success(let credentials):
                    self.user = User(from: credentials.idToken)
                case .failure(let error):
                    print("Failed with: \(error)")
                }
            }
    }

}

struct l_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

