import SwiftUI
import FirebaseEmailAuthUI
import FirebaseOAuthUI
import FirebaseGoogleAuthUI
import FirebaseCore
import FirebaseAuthUI

class AppDelegate: NSObject, UIApplicationDelegate, FUIAuthDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      
        FirebaseApp.configure()
        let authUI = FUIAuth.defaultAuthUI()
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI?.delegate = self

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
}

@main
struct Flight_TracerApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
          NavigationView {
            AppCoordinator()
          }
        }
    }
}

