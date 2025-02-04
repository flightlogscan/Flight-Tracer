import SwiftUI

struct ScanView: View {
    @StateObject var viewModel = UploadPageViewModel()
    @State var activeScanPressed: Bool = false
    @Binding var selectedScanType: ScanType

    var body: some View {
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
                
                ScanButtonView(activeScanPressed: $activeScanPressed, isImageValid: $viewModel.isImageValid)
                    .accessibilityIdentifier("ScanView")
            }
            .navigationDestination(isPresented: $activeScanPressed) {
                if let uiImage = viewModel.selectedImage.uiImage {
                    LogSwiperView(uiImage: uiImage, selectedScanType: selectedScanType)
                        .accessibilityIdentifier("LogSwiperView")
                }
            }
    }
}
