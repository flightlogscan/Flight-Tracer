import SwiftUI

struct AuthCoordinator: View {
    @StateObject private var authManager = AuthManager()

    var body: some View {
        ZStack {
            if !authManager.finishedCheckingLoginStatus {
                Color.navyBlue.ignoresSafeArea()
            } else if !authManager.isLoggedIn {
                LoginView(user: $authManager.user)
                    .ignoresSafeArea()
                    .zIndex(1)
                    .accessibilityIdentifier("LoginView")
            } else if authManager.isLoggedIn {
                AuthenticatedView()
                    .zIndex(1)
            }
        }
        .environmentObject(authManager)
    }
}
