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
            return CustomFUIAuthPickerViewController(authUI: authUI)
        }
    }
}
