import SwiftUI

struct ScanView: View {
    @StateObject var scanViewModel = ScanViewModel()
    @State var activeScanPressed: Bool = false
    @Binding var selectedScanType: ScanType
    @EnvironmentObject var storeKitManager: StoreKitManager

    var body: some View {
        ZStack (alignment: .bottom) {
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [.navyBlue, .black, .black]),
                    startPoint: .top,
                    endPoint: .bottom
                ))
                .edgesIgnoringSafeArea(.all)
                .accessibilityIdentifier("ScanBackground")
            
            VStack {
                ImageHintsView()
                
                ImagePresentationView(parentViewModel: scanViewModel, activeScanPressed: $activeScanPressed)
                    .accessibilityIdentifier("ImagePresentationView")
                    .overlay (
                        PillButtonView(selectedImage: $scanViewModel.selectedImage)
                            .padding(.bottom),
                        alignment: .bottom
                    )
            }
        }
        .navigationDestination(isPresented: $activeScanPressed) {
            if let uiImage = scanViewModel.selectedImage.uiImage {
                LogSwiperView(uiImage: uiImage, selectedScanType: selectedScanType)
                    .environmentObject(storeKitManager)
            }
        }
    }
}

#Preview {
    AuthenticatedView()
}
