import SwiftUI
import PhotosUI

struct ContentView: View {
    
    @State var images: [ImageDetail] = []
    @State var allowScan: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
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
                        
                    ImagePresentationView(selectedImages: $images)
                    
                    HStack {
                        CameraView(selectedImages: $images)
                        PhotoPickerView(selectedImages: $images)
                    }
                    
                    ScanView(allowScan: $allowScan, selectedImages: $images)
                    
                }
                .navigationDestination(isPresented: $allowScan) {
                    // TODO: replace test data with results from processImageText call
                    ScannedFlightLogsView(imageText: [["test", "test2"], ["text", "text2"]])
                }
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
