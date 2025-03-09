import SwiftUI

struct LogSwiperView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authManager: AuthManager
    
    @State var isDataLoaded: Bool = false
    @StateObject var logSwiperViewModel = LogSwiperViewModel()
    
    let uiImage: UIImage
    let selectedScanType: ScanType
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [.navyBlue, .black, .black]),
                    startPoint: .top,
                    endPoint: .bottom
                ))
                .edgesIgnoringSafeArea(.all)
                .accessibilityIdentifier("LogSwiperBackground")
            
            NavigationStack {
                ZStack {
                    if isDataLoaded {
                        LogsView(logSwiperViewModel: logSwiperViewModel)
                    } else {
                        ProgressView()
                            .tint(.white)
                            .padding()
                            .background(.black)
                            .cornerRadius(10)
                            .zIndex(1)
                    }
                }
                .accessibilityIdentifier("LogSwiperView")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        DeleteLogButtonView()
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        ExportButtonView(logSwiperViewModel: logSwiperViewModel)
                    }
                }
                .toolbarBackground(.hidden, for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden()
                .alert("Error detected:", isPresented: $logSwiperViewModel.showAlert) {
                    Button("Back") {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                } message: {
                    Text(logSwiperViewModel.alertMessage)
                }
                .onAppear {
                    logSwiperViewModel.scanImageForLogText(
                        uiImage: uiImage,
                        userToken: authManager.user.token,
                        selectedScanType: selectedScanType
                    )
                }
                .onReceive(logSwiperViewModel.$rows) { rows in
                    isDataLoaded = !rows.isEmpty
                }
            }
        }
        .background(Color.clear)
    }
}
