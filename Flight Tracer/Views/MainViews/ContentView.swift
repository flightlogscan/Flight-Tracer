import SwiftUI
import PhotosUI

struct ContentView: View {
    
    @State var images: [ImageDetail] = []
    @State var allowScan: Bool = false
    @ObservedObject var contentViewModel = ContentViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Text("")
                    .navigationTitle("Flight Log Upload")

                ImageHintsView()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading])
                                
                Spacer()
                SelectImageView(selectedImages: $images)

                // Only allow scanning if every image is valid
                let areImagesValid = (images.count > 0 && images.contains(where: {$0.isImageValid}))
                if (areImagesValid) {
                    Button{
                        allowScan = true
                        //TODO: implement the call below for image text scanning
                        // This is the legit scanner that will back the ultimate output going to the user
                        contentViewModel.processImageText(images: images)
                    } label: {
                        Text("Scan")
                    }
                    .foregroundColor(Color.white)
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(5)
                    .padding()
                }
            }
            .navigationDestination(isPresented: $allowScan) {
                // TODO: replace test data with results from processImageText call
                ScannedFlightLogsView(imageText: [["test", "test2"], ["text", "text2"]])
            }
            Spacer()
            Spacer()
            Spacer()
        }
    }    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
