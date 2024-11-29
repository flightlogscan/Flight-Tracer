import SwiftUI
import FirebaseAuthUI
import Combine

class AuthViewModel: ObservableObject {
    @Published var finishedCheckingLoginStatus = false
    @Published var user: User = User(id: "unknown", email: "unknown@example.com", token: "no-token")
    @Published var isLoggedIn: Bool = false
    let authUI = FUIAuth.defaultAuthUI()

    init() {
        checkLogIn()
    }

    func checkLogIn() {
        Auth.auth().addStateDidChangeListener { [weak self] (_, firebaseUser) in
            guard let self = self else { return }
            if let firebaseUser = firebaseUser {
                firebaseUser.getIDTokenForcingRefresh(true) { idToken, error in
                    if error != nil {
                        print("User token retrieval error")
                        return
                    }
                    self.user = User(id: firebaseUser.uid, email: firebaseUser.email!, token: idToken!)
                    self.isLoggedIn = true
                    self.finishedCheckingLoginStatus = true
                }
                print("Already logged in user: \(String(describing: firebaseUser.email))")
            } else {
                resetUser()
            }
        }
    }
    
    func signOut() {
        do {
            self.resetUser()
            try self.authUI?.signOut()
        } catch let error {
            print("error: \(error)")
        }
    }
    
    func resetUser() {
        self.isLoggedIn = false
        self.finishedCheckingLoginStatus = true
        self.user = User(id: "unknown", email: "unknown@example.com", token: "no-token")
    }
    
    func isAdmin() -> Bool {
        return user.email == "flightlogtracer@gmail.com"
    }
}
