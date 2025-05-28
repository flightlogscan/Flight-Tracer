import SwiftUI

struct AuthCoordinator: View {
    @StateObject private var authManager = AuthManager()
    
    // Listen for subscription transactions at startup
    @StateObject private var storeKitManager = StoreKitManager()

    @State private var isFirstLaunch: Bool = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
    @State private var hasSeenWelcomeView = false
    @State private var hasSeenFreeTrialView = false

    var body: some View {
        ZStack {
            if !authManager.finishedCheckingLoginStatus {
                Color.navyBlue.ignoresSafeArea()
            } else if !authManager.isLoggedIn {
                LoginPageView(user: $authManager.user)
                    .ignoresSafeArea()
                    .accessibilityIdentifier("LoginView")
            } else if authManager.isLoggedIn {
                if (!hasSeenWelcomeView || !hasSeenFreeTrialView) && isFirstLaunch {
                    NavigationStack {
                        if !hasSeenWelcomeView {
                            WelcomeView {
                                hasSeenWelcomeView = true
                                hasSeenFreeTrialView = true
                            }
                        }
                    }
                    .environmentObject(storeKitManager)
                } else {
                    ScansView()
                        .environmentObject(storeKitManager)
                }
            }
        }
        .environmentObject(authManager)
        .task {
            if isFirstLaunch {
                UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            }
            await storeKitManager.listenForTransactions()
        }
    }
}
