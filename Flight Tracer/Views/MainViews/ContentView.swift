import SwiftUI
import PhotosUI

struct ContentView: View {
    
    @State var images: [ImageDetail] = []
    @State var allowScan: Bool = false
    @State var scanTypeSelected: Bool = false
    @ObservedObject var contentViewModel = ContentViewModel()
    
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
                    
                    SelectImageView(selectedImages: $images)
                    
                    // Only allow scanning if every image is valid
                    let areImagesValid = (images.count > 0 && !images.contains(where: {!$0.isImageValid}))
                    
                    Button{
                        allowScan = areImagesValid
                    } label: {
                        Label("Scan photo", systemImage: "doc.viewfinder.fill")
                            .frame(maxWidth: .infinity)
                            .font(.title2)
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(areImagesValid ? .green : .gray.opacity(0.5))
                    .bold()
                    .padding([.leading, .trailing])
                    
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
