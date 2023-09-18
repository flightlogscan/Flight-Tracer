import SwiftUI

struct ImagePresentationView: View {
    
    @Binding var selectedImages: [ImageDetail]
    let recognizedTextProcessor = RecognizedTextProcessor()
    
    var body: some View {
        if selectedImages.count > 0 {
            //TODO: Scroll UI shows one at a time. Need to make each element smaller.
            GeometryReader { geo in
                ScrollView([.vertical], showsIndicators: false) {
                    VStack {
                        ForEach(selectedImages) {image in
                            image.image
                                .resizable()
                                .scaledToFill()
                                .clipped()
                                .padding([.leading, .trailing])
                            
                            if (image.isValidated && !image.isImageValid) {
                                Text("Invalid flight log. Please try a new image.")
                                    .foregroundColor(Color.red)
                            }
                        }
                    }
                    .frame(
                        minWidth: geo.size.width,
                        minHeight: geo.size.height
                    )
                }}
            .frame(maxWidth: selectedImages[0].uiImage.size.width, maxHeight: selectedImages[0].uiImage.size.height)
        } else {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .overlay(
                    Text(Image(systemName: "text.book.closed.fill"))
                        .font(.system(size: 100))
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
