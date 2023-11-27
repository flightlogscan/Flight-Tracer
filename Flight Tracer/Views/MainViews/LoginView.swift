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

        let providers : [FUIAuthProvider] = [
            emailAuth,
            FUIGoogleAuth(authUI: authUI!),
            FUIOAuth.appleAuthProvider()
        ]

        authUI?.providers = providers
        authUI?.delegate = context.coordinator

        let authViewController = authUI?.authViewController()

        // Customization
//        let view = authViewController!.view!
//
//        let marginInsets: CGFloat = 16
//        let imageHeight: CGFloat = 180
//        let imageY = view.center.y - imageHeight
//
//        let logoFrame = CGRect(x: view.frame.origin.x + marginInsets, y: imageY, width: view.frame.width - (marginInsets*2), height: imageHeight)
//
//        let logoImageView = UIImageView(frame: logoFrame)
//        logoImageView.image = UIImage(systemName: "gamecontroller")
//        logoImageView.contentMode = .scaleAspectFit
//        authViewController!.view.addSubview(logoImageView)


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
            
            print("user email \(String(describing: authDataResult?.user.email))")
            if let authDataResult {
                parent.user = User(from: authDataResult)
            } else {
                print("authDataResult null")
            }
        }

        func authUI(_ authUI: FUIAuth, didFinish operation: FUIAccountSettingsOperationType, error: Error?){}
    }
}
