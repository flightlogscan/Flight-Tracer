import SwiftUI
import _PhotosUI_SwiftUI

struct ImagePresentationView: View {
    
    @Binding var selectedImages: [ImageDetail]
    @Binding var selectedItem: PhotosPickerItem?
    let recognizedTextProcessor = RecognizedTextProcessor()
    
    var body: some View {
        if selectedImages.count > 0 {
            //TODO: Scroll UI shows one at a time. Need to make each element smaller.
            GeometryReader { geo in
                VStack {
                    ForEach(selectedImages) {image in
                        image.image
                            .resizable()
                            .cornerRadius(10)
                            .padding([.leading, .trailing])
                            .overlay(
                                Button {
                                    if let idx = selectedImages.firstIndex(of: image) {
                                        selectedImages.remove(at: idx)
                                        selectedItem = nil
                                    }
                                } label: {
                                    Label("", systemImage: "xmark.circle.fill")
                                        .foregroundStyle(.white, .black.opacity(0.7))
                                        .font(.title)
                                        .offset(x: -15, y: 5)
                                },
                                alignment: .topTrailing
                            )
                        
                        if (image.isValidated && !image.isImageValid) {
                            Text("Invalid flight log. Please try a new image.")
                                .foregroundColor(Color.red)
                        }
                    }
                }
            }
            .frame(maxWidth: selectedImages[0].uiImage.size.width, maxHeight: selectedImages[0].uiImage.size.height)
        } else {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .overlay(
                    Text("Please select a photo")
                        .font(.title3)
                        .foregroundColor(.black.opacity(0.7))
                )
                .padding([.leading, .trailing])
        }
    }
}

struct a: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
