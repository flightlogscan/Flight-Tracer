import SwiftUI

struct ContentView: View {
    
    @State var isLeftPickerShowing = false
    @State var isRightPickerShowing = false
    @State var leftImage: UIImage?
    @State var rightImage: UIImage?
    @ObservedObject var contentViewModel = ContentViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                
                let areBothImagesSelected = leftImage != nil && rightImage != nil
                Text("")
                    .navigationTitle("Flight Log Selection")

                ImageHintsView()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading])
                
                Spacer()
                UploadImageView(selectedImage: $leftImage, isPickerShowing: $isLeftPickerShowing)
                
                if (self.contentViewModel.isLeftImageValid != nil && !self.contentViewModel.isLeftImageValid!) {
                    Text("Invalid flight log. Please try a new image.")
                        .foregroundColor(Color.red)
                }
                Spacer()
                UploadImageView(selectedImage: $rightImage, isPickerShowing: $isRightPickerShowing)
                if (self.contentViewModel.isRightImageValid != nil && !self.contentViewModel.isRightImageValid!) {
                    Text("Invalid flight log. Please try a new image.")
                        .foregroundColor(Color.red)
                }
                Spacer()
                
                
                Button{
                    let leftImageText = contentViewModel.scanImage(image: leftImage, pageSide: PageSide.left)
                    let rightImageText = contentViewModel.scanImage(image: rightImage, pageSide: PageSide.right)
                    contentViewModel.checkAreAllImagesValid()
                    contentViewModel.processImageText(imageText: leftImageText, pageSide: PageSide.left)
                    contentViewModel.processImageText(imageText: rightImageText, pageSide: PageSide.right)
                    contentViewModel.mergeImageText()
                } label : {
                    Text("Scan")
                }
                .foregroundColor(areBothImagesSelected ? Color.white : Color.white.opacity(0.5))
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(areBothImagesSelected ? Color.blue : Color.gray)
                .cornerRadius(5)
                .padding()
            }
            .navigationDestination(isPresented: $contentViewModel.areAllImagesValid) {
                EditableLogGridView(imageText: self.contentViewModel.mergedGrids)
            }
        }
    }    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
