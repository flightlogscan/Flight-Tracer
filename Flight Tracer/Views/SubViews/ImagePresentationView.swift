import SwiftUI

struct ImagePresentationView: View {
    
    @Binding var selectedImages: [ImageDetail]
    let recognizedTextProcessor = RecognizedTextProcessor()
    
    var body: some View {
        if selectedImages.count > 0 {
            //TODO: Scroll UI shows one at a time. Need to make each element smaller.
            ScrollView([.vertical], showsIndicators: false) {
                ForEach(selectedImages) {image in
                    
                    image.image
                        .resizable()
                        .scaledToFit()
                        .clipped()
                        .padding([.leading, .trailing])
                    
                    if (image.isValidated && !image.isImageValid) {
                        Text("Invalid flight log. Please try a new image.")
                            .foregroundColor(Color.red)
                    }
                }
            }
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
