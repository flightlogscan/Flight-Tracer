import SwiftUI
import FirebaseAuthUI
import PhotosUI

struct UploadPageView: View {
    
    @StateObject var viewModel = UploadPageViewModel()
    @State var activeScanPressed: Bool = false
    @State var selectedOption: Int = 0 // TODO: Default to real API call instead of localhost
         
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .fill(Color(.systemGray6))
                    .edgesIgnoringSafeArea(.all)
                    .accessibilityIdentifier("Background")

                VStack {
                    ImageHintsView()
                        .accessibilityIdentifier("ImageHintsView")

                    ImagePresentationView(selectedImage: $viewModel.selectedImage)
                        .accessibilityIdentifier("ImagePresentationView")
                    
                    PhotoCarouselView(selectedImage: $viewModel.selectedImage)
                        .accessibilityIdentifier("PhotoCarouselView")
                    
                    ScanView(activeScanPressed: $activeScanPressed, selectedImage: $viewModel.selectedImage)
                        .accessibilityIdentifier("ScanView")
                }
                .navigationDestination(isPresented: $activeScanPressed) {
                    LogSwiperView(selectedImage: $viewModel.selectedImage, selectedScanType: selectedOption)
                        .accessibilityIdentifier("LogSwiperView")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Flight Log Tracer")
                        .font(.custom(
                            "Magnolia Script",
                            fixedSize: 20))
                        .foregroundStyle(.white)
                        .accessibilityIdentifier("ToolbarTitle")
                }
                ToolbarItem(placement: .primaryAction) {
                    OptionsMenu(selectedOption: $selectedOption)
                        .accessibilityIdentifier("OptionsMenu")
                }
            }
            .tint(.white)
            .toolbarBackground(
                Color.navyBlue,
                for: .navigationBar
            )
            .toolbarBackground(.visible, for: .navigationBar)
            .onAppear {
                viewModel.resetAnalyzeResult()
            }
        }
    }
}

#Preview {
    UploadPageView()
}
