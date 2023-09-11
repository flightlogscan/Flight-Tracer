import SwiftUI
import _PhotosUI_SwiftUI

struct SelectImageView: View {
    
    @State private var selectedItems: [PhotosPickerItem] = []
    @Binding var selectedImages: [ImageDetail]
    @ObservedObject var selectImageViewModel = SelectImageViewModel()
    let recognizedTextProcessor = RecognizedTextProcessor()
    
    var body: some View {
        
        let photosPicker = PhotosPicker(selection: $selectedItems, matching: .images) {
            Label("Select photos", systemImage: "photo")
        }
            .cornerRadius(10)
            .foregroundColor(Color.black)
            .buttonStyle(.borderedProminent)
            .onChange(of: selectedItems) { newItem in
                Task {
                    selectedImages = []
                    for item in selectedItems {
                        if let data = try? await item.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data) {
                                let image = Image(uiImage: uiImage)
                                let isValidated = true
                                
                                let imageDetail = ImageDetail(image: image, uiImage: uiImage, isValidated: isValidated)
                                
                                // This uses a very basic image scanner as a first-step sanity-check
                                // before allowing users to send the image to the more resource-intensive scanner
                                selectImageViewModel.simpleValidateImage(image: imageDetail)
                                
                                selectedImages.append(imageDetail)
                            }
                        }
                    }
                }
            }
        
        // TODO: All the images are constrained a fixed size, would be cool to enable scrolling through all of them
        if selectedImages.count > 0 {
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
            Spacer()
            CameraView()
            photosPicker
        } else {
            //Update placeholder image
            let placeholderImage = UIImage(named: "suns")
            Image(uiImage: placeholderImage!)
            Spacer()
            CameraView()
            photosPicker
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
