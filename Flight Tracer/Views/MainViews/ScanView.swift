import SwiftUI

struct ScanView: View {
    @StateObject var scanViewModel = ScanViewModel()
    @State var activeScanPressed: Bool = false
    @Binding var selectedScanType: ScanType
    @EnvironmentObject var storeKitManager: StoreKitManager

    var body: some View {
        Rectangle()
            .fill(Color(.systemGray6))
            .edgesIgnoringSafeArea(.all)
            .accessibilityIdentifier("Background")

            VStack {
                ImageHintsView()
                    .accessibilityIdentifier("ImageHintsView")
                
                ImagePresentationView(parentViewModel: scanViewModel)
                    .accessibilityIdentifier("ImagePresentationView")
                
                PhotoCarouselView(selectedImage: $scanViewModel.selectedImage)
                    .accessibilityIdentifier("PhotoCarouselView")
                
                ScanButtonView(activeScanPressed: $activeScanPressed, isImageValid: $scanViewModel.isImageValid)
                    .accessibilityIdentifier("ScanView")
            }
            .navigationDestination(isPresented: $activeScanPressed) {
                if let uiImage = scanViewModel.selectedImage.uiImage {
                    LogSwiperView(uiImage: uiImage, selectedScanType: selectedScanType)
                        .environmentObject(storeKitManager)
                        .accessibilityIdentifier("LogSwiperView")
                }
            }
    }
}

#Preview {
    AuthenticatedView()
}
