import SwiftUI
import _PhotosUI_SwiftUI

struct SelectImageView: View {
    
    @State private var selectedImage: Image?
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var isValidated: Bool = false
    @Binding var isImageValid: Bool
    @Binding var selectedImages: [ImageDetail]
    @ObservedObject var selectImageViewModel = SelectImageViewModel()
    let recognizedTextProcessor = RecognizedTextProcessor()
    
    var body: some View {
        
        let photosPicker = PhotosPicker(selection: $selectedItems, matching: .images) {
            Label("Select photos", systemImage: "photo")
        }
        //.tint(.gray.opacity(0.1))
            .cornerRadius(10)
            .foregroundColor(Color.black)
            .buttonStyle(.borderedProminent)
            .onChange(of: selectedItems) { newItem in
                Task {
                    selectedImages = []
                    for item in selectedItems {
                        if let data = try? await item.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data) {
                                selectedImage = Image(uiImage: uiImage)
                                let image = Image(uiImage: uiImage)
                                selectImageViewModel.simpleValidateImage(image: uiImage)
                                isValidated = true
                                isImageValid = self.selectImageViewModel.isImageValid
                                
                                let imageDetail = ImageDetail(image: image, isValidated: isValidated, isImageValid: isImageValid)
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
        
        if (isValidated && !isImageValid) {
            Text("Invalid flight log. Please try a new image.")
                .foregroundColor(Color.red)
        }
    }
}

public struct ImageDetail: Identifiable {
    public var id = UUID()
    
    @State var image: Image
    @State var isValidated: Bool
    @State var isImageValid: Bool
}
