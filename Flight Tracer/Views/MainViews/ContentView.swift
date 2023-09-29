import SwiftUI
import PhotosUI

struct ContentView: View {
    
    @State var images: [ImageDetail] = []
    @State var allowScan: Bool = false
    @State var scanTypeSelected: Bool = false
    @State var selectedItem: PhotosPickerItem?
    @ObservedObject var contentViewModel = ContentViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .fill(Color(.systemGray6))
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Flight Log Upload")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .bold()
                        .padding([.leading, .top, .bottom])
                    
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
