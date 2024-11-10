import SwiftUI
import FirebaseAuthUI

struct ContentView: View {
    @State var user: User?
    @State var isLoggedIn: Bool?

    var body: some View {
        
        ZStack {
            if (user == nil && isLoggedIn == nil){
                Color(uiColor: Colors.NAVY_BLUE!).ignoresSafeArea()
            } else if (user == nil || !isLoggedIn!) {
                LoginView(user: $user)
                    .ignoresSafeArea()
                    .zIndex(1)
            } else if (user != nil && isLoggedIn!){
                UploadPageView(user: $user)
                    .zIndex(1)
            }
        }
        .onAppear {
            self.checkLogIn()
        }
    }
    
    func checkLogIn() {
        Auth.auth().addStateDidChangeListener { [self] (_, user) in
            if let user = user {
                self.user = User(id: user.uid, email: user.email!)
                 
                user.getIDTokenForcingRefresh(true) { idToken, error in
                    if error != nil {
                        print("user token retrieval error")
                        isLoggedIn = false
                        return;
                    }

                    //print("id token \(String(describing: idToken))")
                    self.user?.token = idToken
                }
                isLoggedIn = true
                
                print("already logged in user: \(String(describing: user.email))")
            } else {
                isLoggedIn = false
            }
        }
    }
}

struct l_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(user: nil, isLoggedIn: nil)
    }
}
