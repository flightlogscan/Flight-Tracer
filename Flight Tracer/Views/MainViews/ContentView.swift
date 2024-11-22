import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        ZStack {
            if viewModel.user == nil && viewModel.isLoggedIn == nil {
                Color.navyBlue.ignoresSafeArea()
            } else if viewModel.user == nil || viewModel.isLoggedIn == false {
                LoginView(user: $viewModel.user)
                    .ignoresSafeArea()
                    .zIndex(1)
            } else if viewModel.user != nil && viewModel.isLoggedIn == true {
                UploadPageView()
                    .zIndex(1)
            }
        }
        .environmentObject(viewModel)
    }
}
