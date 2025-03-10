import SwiftUI

struct AuthCoordinator: View {
    @StateObject private var authManager = AuthManager()
    
    // Listen for subscription transactions at startup
    @StateObject private var storeKitManager = StoreKitManager()

    var body: some View {
        ZStack {
            if !authManager.finishedCheckingLoginStatus {
                Color.navyBlue.ignoresSafeArea()
            } else if !authManager.isLoggedIn {
                LoginPageView(user: $authManager.user)
                    .ignoresSafeArea()
                    .zIndex(1)
                    .accessibilityIdentifier("LoginView")
            } else if authManager.isLoggedIn {
                AuthenticatedView()
                    .environmentObject(storeKitManager)
                    .zIndex(1)
            }
        }
        .environmentObject(authManager)
    }
}
