import SwiftUI
import FirebaseAuthUI
import PhotosUI

struct UploadPageView: View {
    
    @State var selectedImage: ImageDetail = ImageDetail()
    @State var allowScan: Bool = false
    @State var scanTypeSelected: Bool = false
    @State var selectedItem: PhotosPickerItem?
    @State var selectedOption: Int = 0
    @Binding var user: User?
    @ObservedObject var contentViewModel = ContentViewModel()
    let authUI = FUIAuth.defaultAuthUI()
         
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .fill(Color(.systemGray6))
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    ImageHintsView()
                                          
                    ImagePresentationView(selectedImage: $selectedImage, selectedItem: $selectedItem)
                    
                    PhotoCarouselView(selectedImage: $selectedImage, selectedItem: $selectedItem)
                    
                    ScanView(allowScan: $allowScan, selectedImage: $selectedImage, user: $user)
                }
                .navigationDestination(isPresented: $allowScan) {
                    TablePageView(selectedImage: selectedImage, selectedScanType: selectedOption, user: $user)
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                OptionsMenu(selectedOption: $selectedOption, user: $user, authUI: authUI)
            }
            .tint(.white)
            .toolbarBackground(
                Color(red: 0.0, green: 0.2, blue: 0.5),
                for: .navigationBar
            )
            .toolbarBackground(.visible, for: .navigationBar)
            .onAppear() {
                selectedImage.analyzeResult = nil
            }
        }
    }
    
    
}


#Preview {
    UploadPageView(user: Binding.constant(nil))
}
