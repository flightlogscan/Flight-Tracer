import SwiftUI
import FirebaseAuthUI
import PhotosUI

struct UploadPageView: View {
    
    @StateObject var viewModel = UploadPageViewModel()
    @State var activeScanPressed: Bool = false
    @State var selectedScanType: ScanType = .localhost // TODO: Default to real API call instead of localhost
         
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

                    ImagePresentationView(parentViewModel: viewModel)
                        .accessibilityIdentifier("ImagePresentationView")
                    
                    PhotoCarouselView(selectedImage: $viewModel.selectedImage)
                        .accessibilityIdentifier("PhotoCarouselView")
                    
                    ScanView(activeScanPressed: $activeScanPressed, isImageValid: $viewModel.isImageValid)
                        .accessibilityIdentifier("ScanView")
                }
                .navigationDestination(isPresented: $activeScanPressed) {
                    if let uiImage = viewModel.selectedImage.uiImage {
                        LogSwiperView(uiImage: uiImage, selectedScanType: selectedScanType)
                            .accessibilityIdentifier("LogSwiperView")
                    }
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
                    OptionsMenu(selectedScanType: $selectedScanType)
                        .accessibilityIdentifier("OptionsMenu")
                }
            }
            .tint(.white)
            .toolbarBackground(
                Color.navyBlue,
                for: .navigationBar
            )
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

#Preview {
    UploadPageView()
}
