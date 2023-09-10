import SwiftUI
import PhotosUI

struct ContentView: View {
    
    @State var isImageValid = false
    @State var images: [ImageDetail] = []
    @State var doScanImage = false
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
                SelectImageView(isImageValid: $isImageValid, selectedImages: $images)

                // Only allow scanning if every image is valid
                if (!images.contains(where: {$0.isImageValid})) {
                    Button{
                        doScanImage = isImageValid
                        //TODO: implement the call below for image text scanning
                        //contentViewModel.processImageText(imageText: imageText)
                    } label : {
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
            .navigationDestination(isPresented: $doScanImage) {
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
