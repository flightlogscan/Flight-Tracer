import SwiftUI
import FirebaseOAuthUI
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseEmailAuthUI

struct LoginView : UIViewControllerRepresentable {
    
    @Binding var user: User?
    
    func makeCoordinator() -> LoginView.Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIViewController
    {
        let auth = Auth.auth()
        
        // Check if user has already logged in
        auth.addStateDidChangeListener { [self] (_, user) in
            if let user = user {
                self.user = User(id: user.uid, email: user.email!)
                print("already logged in user: \(String(describing: user.email))")
            }
        }
        
        //Get id token to send to backend
//        let currentUser = FIRAuth.auth()?.currentUser
//        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
//          if let error = error {
//            // Handle error
//            return;
//          }
//
//          // Send token to your backend via HTTPS
//          // ...
//        }
        
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.shouldHideCancelButton = true
        
        let settings = ActionCodeSettings()

        let emailAuth = FUIEmailAuth(
          authAuthUI: authUI!,
          signInMethod: EmailPasswordAuthSignInMethod,
          forceSameDevice: false,
          allowNewEmailAccounts: true,
          requireDisplayName: false,
          actionCodeSetting: settings
        )
        emailAuth.buttonAlignment = .center
        
        let googleAuth = FUIGoogleAuth(authUI: authUI!)
        googleAuth.buttonAlignment = .center

        let providers : [FUIAuthProvider] = [
            emailAuth,
            googleAuth,
            //https://firebase.google.com/docs/auth/ios/apple
            //Apple requires enrollment which seems like a pain so do later: https://developer.apple.com/programs/enroll/
            //FUIOAuth.appleAuthProvider()
        ]

        authUI?.providers = providers
        authUI?.delegate = context.coordinator

        let authViewController = authUI?.authViewController()

        return authViewController!
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<LoginView>)
    {
    }

    // Coordinator
    class Coordinator : NSObject, FUIAuthDelegate {
        
        var parent : LoginView
        
        init(_ parent : LoginView) {
            self.parent = parent
        }
        
        func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?){
            
            if let authDataResult {
                parent.user = User(from: authDataResult)
                authDataResult.user.getIDToken()
                print("user \(String(describing: parent.user))")
            } else {
                print("authDataResult null")
            }
        }
        
        func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
            return CustomAuthPickerViewController(authUI: authUI)
        }
        
        func emailEntryViewController(forAuthUI authUI: FUIAuth) -> FUIEmailEntryViewController {
            return CustomEmailEntryViewController(authUI: authUI)
        }
        
        func passwordSignUpViewController(forAuthUI authUI: FUIAuth, email: String?, requireDisplayName: Bool) -> FUIPasswordSignUpViewController {
            return CustomPasswordSignUpViewController(authUI: authUI, email: email, requireDisplayName: false)
        }
        
        func passwordSignInViewController(forAuthUI authUI: FUIAuth, email: String?) -> FUIPasswordSignInViewController {
            return CustomPasswordSignInViewController(authUI: authUI, email: email)
        }
        
        func passwordVerificationViewController(forAuthUI authUI: FUIAuth, email: String?, newCredential: AuthCredential) -> FUIPasswordVerificationViewController {
            return CustomPasswordVerificationViewController(authUI: authUI, email: email, newCredential: newCredential)
        }
        
        func passwordRecoveryViewController(forAuthUI authUI: FUIAuth, email: String?) -> FUIPasswordRecoveryViewController {
            return CustomPasswordRecoveryViewController(authUI: authUI, email: email)
        }

    }
}

#Preview {
    ContentView()
}
