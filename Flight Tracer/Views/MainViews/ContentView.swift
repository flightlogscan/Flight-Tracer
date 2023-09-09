import SwiftUI
import PhotosUI

struct ContentView: View {
    
    @State var isButtonPressed = false
    @State var isImageValid = false
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
                UploadImageView(isImageValid: $isImageValid)
                    
                Spacer()
                
                Button{
                    doScanImage = isImageValid
                    //TODO: implement the call below for image text scanning
                    //contentViewModel.processImageText(imageText: imageText)
                } label : {
                    Text("Scan")
                }
                .foregroundColor(isImageValid == true ? Color.white : Color.white.opacity(0.5))
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(isImageValid == true ? Color.blue : Color.gray)
                .cornerRadius(5)
                .padding()
            }
            .navigationDestination(isPresented: $doScanImage) {
                // TODO: replace test data with results from processImageText call
                ScannedFlightLogsView(imageText: [["test", "test2"], ["text", "text2"]])
            }
        }
    }    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
