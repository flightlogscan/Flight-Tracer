import SwiftUI

struct SelectImageView: View {
    
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
            //Update placeholder image
            let placeholderImage = UIImage(named: "suns")
            Image(uiImage: placeholderImage!)
            Spacer()
            CameraView(selectedImages: $selectedImages)
            PhotoPickerView(selectedImages: $selectedImages)
        }
    }
}

public struct ImageDetail: Identifiable {
    public var id = UUID()
    
    @State var image: Image
    @State var uiImage: UIImage
    @State var isValidated: Bool = false // TODO: Is this field used for anything anymore?
    @State var isImageValid: Bool = false
    @State var imageText: [String] = [] // Basic image text from the simple image scanner
    @State var recognizedText: [[String]] = [[]] // Advanced image text from the heavy-duty image scanner
}
