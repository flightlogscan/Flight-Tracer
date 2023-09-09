import SwiftUI
import _PhotosUI_SwiftUI

struct SelectImageView: View {

    @State private var selectedImage: Image?
    @State private var selectedItem: PhotosPickerItem?
    @State private var isValidated: Bool = false
    @Binding var isImageValid: Bool
    @ObservedObject var selectImageViewModel = SelectImageViewModel()
    let recognizedTextProcessor = RecognizedTextProcessor()
    
    var body: some View {
        
        let photosPicker = PhotosPicker(selection: $selectedItem, matching: .images) {
            Label("Select a photo", systemImage: "photo")
        }
        .tint(.gray.opacity(0.1))
        .cornerRadius(10)
        .foregroundColor(Color.black)
        .buttonStyle(.borderedProminent)
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        selectedImage = Image(uiImage: uiImage)
                        selectImageViewModel.simpleValidateImage(image: uiImage)
                        isValidated = true
                        isImageValid = self.selectImageViewModel.isImageValid
                        return
                    }
                }
            }
        }
        
        if let selectedImage {
            selectedImage
                .resizable()
                .scaledToFit()
                .clipped()
                .opacity(0.3)
                .cornerRadius(10)
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
