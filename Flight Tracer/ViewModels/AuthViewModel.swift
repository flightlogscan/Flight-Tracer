import SwiftUI
import FirebaseAuthUI
import Combine

class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoggedIn: Bool? = nil
    let authUI = FUIAuth.defaultAuthUI()

    init() {
        checkLogIn()
    }

    func checkLogIn() {
        Auth.auth().addStateDidChangeListener { [weak self] (_, firebaseUser) in
            guard let self = self else { return }
            if let firebaseUser = firebaseUser {
                self.user = User(id: firebaseUser.uid, email: firebaseUser.email!)
                 
                firebaseUser.getIDTokenForcingRefresh(true) { idToken, error in
                    if error != nil {
                        print("User token retrieval error")
                        self.isLoggedIn = false
                        return
                    }
                    self.user?.token = idToken
                }
                self.isLoggedIn = true
                print("Already logged in user: \(String(describing: firebaseUser.email))")
            } else {
                self.isLoggedIn = false
            }
        }
    }
    
    func signOut() {
        self.user = nil
        do {
            try self.authUI?.signOut()
        } catch let error {
            print("error: \(error)")
        }
    }
}
