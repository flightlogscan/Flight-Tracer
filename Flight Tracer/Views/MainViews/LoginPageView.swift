import SwiftUI
import FirebaseOAuthUI
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseEmailAuthUI

struct LoginView : UIViewControllerRepresentable {
    
    @Binding var user: User
    
    func makeCoordinator() -> LoginView.Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIViewController
    {
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.shouldHideCancelButton = true
        
       // let settings = ActionCodeSettings()

//        let emailAuth = FUIEmailAuth(
//          authAuthUI: authUI!,
//          signInMethod: EmailPasswordAuthSignInMethod,
//          forceSameDevice: false,
//          allowNewEmailAccounts: true,
//          requireDisplayName: false,
//          actionCodeSetting: settings
//        )
        
        let googleAuth = FUIGoogleAuth(authUI: authUI!)
        let appleAuth = FUIOAuth.appleAuthProvider(withAuthUI: authUI!, userInterfaceStyle: .dark)

        let providers : [FUIAuthProvider] = [
            appleAuth,
            googleAuth,
            //TODO: This email sign up is an ugly UI. Might be unnecessary. We can add it back if users request.
            // emailAuth,
        ]

        authUI?.providers = providers 
        authUI?.delegate = context.coordinator

        let authViewController = authUI?.authViewController()

        return authViewController!
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<LoginView>){}

    class Coordinator : NSObject, FUIAuthDelegate {
        
        var parent : LoginView
        
        init(_ parent : LoginView) {
            self.parent = parent
        }
        
        // TODO: Do we need all these prints? Great question! Yes we do.
        func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?){
            
            if let authDataResult {
                authDataResult.user.getIDTokenForcingRefresh(true) { idToken, error in
                    if error != nil {
                        // Handle error
                        print("user token retrieval error: \(String(describing: error))")
                        return;
                    }

                    if (authDataResult.user.email != nil && idToken != nil) {
                        self.parent.user = User(id: authDataResult.user.uid, email: authDataResult.user.email!, token: idToken!)
                    } else {
                        print("authDataResult missing email or token")
                    }

                    print("user \(String(describing: self.parent.user))")
                }
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
    AppCoordinator()
}
