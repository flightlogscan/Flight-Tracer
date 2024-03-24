import SwiftUI
import FirebaseAuthUI
import PhotosUI

struct FlightLogUploadView: View {
    
    @State var image: ImageDetail? = ImageDetail()
    @State var allowScan: Bool = false
    @State var scanTypeSelected: Bool = false
    @State var selectedItem: PhotosPickerItem?
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
                                          
                    ImagePresentationView(selectedImage: $image, selectedItem: $selectedItem)
                    
                    PhotoCarouselView(selectedImage: $image, selectedItem: $selectedItem)
                    
                    ScanView(allowScan: $allowScan, selectedImage: $image, user: $user)
                }
                .navigationDestination(isPresented: $allowScan) {
                    ExperimentalTable(selectedImage: $image, user: $user)
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem (placement: .principal) {
                    Image(systemName: "airplane.departure")
                        .foregroundStyle(.white)
                }
            
                ToolbarItem {
                    Menu {
                        Button {
                            user = nil
                            do {
                                try self.authUI?.signOut()
                            } catch let error {
                                print("error: \(error)")
                            }
                        } label: {
                            Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                    } label: {
                        Label("", systemImage: "gearshape")
                    }
                }
            }
            .tint(.white)
            .toolbarBackground(
                Color(red: 0.0, green: 0.2, blue: 0.5),
                for: .navigationBar
            )
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

#Preview {
    FlightLogUploadView(user: Binding.constant(nil))
}
