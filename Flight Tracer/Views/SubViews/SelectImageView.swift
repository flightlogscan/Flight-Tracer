import SwiftUI

struct SelectImageView: View {
    
    @Binding var selectedImages: [ImageDetail]
    let recognizedTextProcessor = RecognizedTextProcessor()
    
    var body: some View {
        
        Spacer()
        Spacer()
        Spacer()
        if selectedImages.count > 0 {
            //TODO: Scroll UI shows one at a time. Need to make each element smaller.
            ScrollView([.vertical], showsIndicators: false) {
                ForEach(selectedImages) {image in
                    image.image
                        .resizable()
                        .scaledToFit()
                        .clipped()
                    
                    if (image.isValidated && !image.isImageValid) {
                        Text("Invalid flight log. Please try a new image.")
                            .foregroundColor(Color.red)
                    }
                }
            }
            Spacer()
            CameraView(selectedImages: $selectedImages)
            PhotoPickerView(selectedImages: $selectedImages)
                
        } else {
            HStack {
                Spacer()
                Spacer()
                Rectangle()
                    .foregroundColor(.gray.opacity(0.2))
                    .cornerRadius(5)
                    .overlay(
                        Text(Image(systemName: "text.book.closed.fill"))
                            .font(.system(size: 150))
                            .foregroundColor(.gray)
                    )
                Spacer()
                Spacer()
            }

            Spacer()
            Spacer()
            Spacer()
            CameraView(selectedImages: $selectedImages)
            PhotoPickerView(selectedImages: $selectedImages)
        }
    }
}

public class ImageDetail: Identifiable {
    public var id = UUID()
    
    var image: Image
    var uiImage: UIImage
    var isValidated: Bool // TODO: Is this field used for anything anymore?
    var isImageValid: Bool
    var imageText: [String] // Basic image text from the simple image scanner
    var recognizedText: [[String]] // Advanced image text from the heavy-duty image scanner
    
    init (image: Image, uiImage: UIImage, isValidated: Bool) {
        self.image = image
        self.uiImage = uiImage
        self.isValidated = isValidated
        self.isImageValid = false
        self.imageText = []
        self.recognizedText = [[]]
    }
}
