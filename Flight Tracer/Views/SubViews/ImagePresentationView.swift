import SwiftUI
import _PhotosUI_SwiftUI

struct ImagePresentationView: View {
    
    @Binding var selectedImages: [ImageDetail]
    @Binding var selectedItem: PhotosPickerItem?
    let recognizedTextProcessor = RecognizedTextProcessor()
    
    var body: some View {
        if selectedImages.count > 0 {
            VStack {
                ForEach(selectedImages) {image in
                selectedImages[0].image
                        .resizable()
                        .cornerRadius(10)
                        //.aspectRatio(1, contentMode: .fit)
                        .padding([.leading, .trailing])
                        .overlay(
                            Button {
                                if let idx = selectedImages.firstIndex(of: selectedImages[0]) {
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
                    
                    if (selectedImages[0].isValidated && !selectedImages[0].isImageValid) {
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
                    Text("Please select a photo")
                        .font(.title3)
                        .foregroundColor(.black.opacity(0.7))
                )
                .padding([.leading, .trailing])
        }
    }
}

