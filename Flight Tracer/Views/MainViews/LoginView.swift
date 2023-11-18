import SwiftUI
import Auth0

struct LoginView: View {
    @State var user: User?

    var body: some View {
        if let user = self.user {
            VStack {
                ContentView()
                Button("Logout", action: self.logout)
            }
        } else {
            VStack {
                Button("Login", action: self.login)
            }
        }
    }
}

extension LoginView {
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

    func logout() {
        self.user = nil
    }
}

struct l_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

