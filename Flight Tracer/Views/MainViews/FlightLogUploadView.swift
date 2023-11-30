import SwiftUI
import FirebaseAuthUI
import PhotosUI

struct FlightLogUploadView: View {
    
    @State var images: [ImageDetail] = []
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
                    HStack {
                        Text("Flight Log Upload")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.largeTitle)
                            .foregroundColor(.black)
                            .bold()
                            .padding([.leading, .top, .bottom])
                        
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
                            Label("", systemImage: "gearshape.fill")
                                .font(.title)
                                .foregroundColor(.black)
                        }
                    }
                    
                    ImageHintsView()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading])
                        .foregroundColor(.black)
                                          
                    ImagePresentationView(selectedImages: $images, selectedItem: $selectedItem)
                                        
                    HStack {
                        CameraView(selectedImages: $images)
                        PhotoPickerView(selectedItem: $selectedItem, selectedImages: $images)
                    }
                    
                    ScanView(allowScan: $allowScan, selectedImages: $images)
                }
                .navigationDestination(isPresented: $allowScan) {
                    // TODO: Remove dev-only warning view and replace with real logic (commented out below)
                    WarningView(images: images, allowScan: allowScan, scanTypeSelected: scanTypeSelected, contentViewModel: contentViewModel)
                    
                    // contentViewModel.processImageText(images: images, realScan: true)
                    // ScannedFlightLogsView(imageText: [["test", "test2"], ["text", "text2"]])
                }
            }
        }
    }
}
