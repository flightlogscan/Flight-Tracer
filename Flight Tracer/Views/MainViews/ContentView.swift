import SwiftUI
import PhotosUI

struct ContentView: View {
    
    @State var images: [ImageDetail] = []
    @State var allowScan: Bool = false
    @ObservedObject var contentViewModel = ContentViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Rectangle().overlay(
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
                        }
                    )
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding([.leading, .trailing])
                        
                    ImagePresentationView(selectedImages: $images)
                    
                    SelectImageView(selectedImages: $images)
                    
                    // Only allow scanning if every image is valid
                    let areImagesValid = (images.count > 0 && !images.contains(where: {!$0.isImageValid}))
                    
                    Button{
                        allowScan = areImagesValid
                        //TODO: implement the call below for image text scanning
                        // This is the legit scanner that will back the ultimate output going to the user
                        if (allowScan) {
                            contentViewModel.processImageText(images: images)
                        }
                    } label: {
                        Label("Scan photo", systemImage: "doc.viewfinder.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(areImagesValid ? .green : .gray)
                    .bold()
                    .padding()
                    
                }
                .navigationDestination(isPresented: $allowScan) {
                    // TODO: replace test data with results from processImageText call
                    ScannedFlightLogsView(imageText: [["test", "test2"], ["text", "text2"]])
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
