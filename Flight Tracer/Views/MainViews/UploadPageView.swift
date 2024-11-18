import SwiftUI
import FirebaseAuthUI
import PhotosUI

struct UploadPageView: View {
    
    @StateObject var viewModel = UploadPageViewModel()
    @State var activeScanPressed: Bool = false
    @State var selectedOption: Int = 0 // TODO: Default to real API call instead of localhost
    @Binding var user: User?
         
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .fill(Color(.systemGray6))
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    ImageHintsView()
                                          
                    ImagePresentationView(selectedImage: $viewModel.selectedImage)
                    
                    PhotoCarouselView(selectedImage: $viewModel.selectedImage)
                    
                    ScanView(activeScanPressed: $activeScanPressed, selectedImage: $viewModel.selectedImage)
                }
                .navigationDestination(isPresented: $activeScanPressed) {
                    LogSwiperView(selectedImage: $viewModel.selectedImage, selectedScanType: selectedOption, user: user)
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem (placement: .principal) {
                    Text("Flight Log Tracer")
                        .font(.custom(
                            "Magnolia Script",
                            fixedSize: 20))
                        .foregroundStyle(.white)
                }
                ToolbarItem (placement: .primaryAction) {
                    OptionsMenu(selectedOption: $selectedOption, user: $user)
                }
            }
            .tint(.white)
            .toolbarBackground(
                Color.navyBlue,
                for: .navigationBar
            )
            .toolbarBackground(.visible, for: .navigationBar)
            .onAppear() {
                viewModel.resetAnalyzeResult()
            }
        }
    }
}


#Preview {
    UploadPageView(user: Binding.constant(nil))
}
