import SwiftUI

struct ScanView: View {
    @StateObject var scanViewModel = ScanViewModel()
    
    @State var activeScanPressed: Bool = false
    @State var isScanningDisabled: Bool = true
    @State private var showHintsSheet: Bool = false
    
    @Binding var selectedScanType: ScanType
    @Binding var showStore: Bool
    @Binding var showScanSheet: Bool
    
    @EnvironmentObject var storeKitManager: StoreKitManager

    var body: some View {
        NavigationStack {
            ZStack (alignment: .top) {
                Rectangle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.navyBlue, .black, .black]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .ignoresSafeArea(.all)
                    .accessibilityIdentifier("ScanBackground")
                
                VStack {
                    ImagePresentationView(parentViewModel: scanViewModel, showStore: $showStore)
                        .accessibilityIdentifier("ImagePresentationView")
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    DismissScreenCoverButton()
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    ScanButtonView(
                        scanPressed: $activeScanPressed,
                        isDisabled: $isScanningDisabled
                    )
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .onAppear {
                if !UserDefaults.standard.bool(forKey: "hasShownHintsOnce") {
                    showHintsSheet = true
                    UserDefaults.standard.set(true, forKey: "hasShownHintsOnce")
                }
            }
            .onChange(of: scanViewModel.isImageValid) { _, _ in
                isScanningDisabled = !scanViewModel.isImageValid
            }
            .navigationDestination(isPresented: $activeScanPressed) {
                if let uiImage = scanViewModel.selectedImage.uiImage {
                    LogSwiperView(showScanSheet: $showScanSheet, uiImage: uiImage, selectedScanType: selectedScanType)
                        .environmentObject(storeKitManager)
                }
            }
            .sheet(isPresented: $showHintsSheet) {
                ImageHintsView(showHintsSheet: $showHintsSheet)
            }
        }
    }
}

#Preview {
    ScansView()
}
