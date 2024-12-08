import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        ZStack {
            if !viewModel.finishedCheckingLoginStatus {
                Color.navyBlue.ignoresSafeArea()
            } else if viewModel.isLoggedIn == false {
                LoginView(user: $viewModel.user)
                    .ignoresSafeArea()
                    .zIndex(1)
                    .accessibilityIdentifier("LoginView")
            } else if viewModel.isLoggedIn == true {
                UploadPageView()
                    .zIndex(1)
            }
        }
        .environmentObject(viewModel)
    }
}
