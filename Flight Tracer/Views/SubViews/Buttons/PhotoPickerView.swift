import SwiftUI
import Photos
import PhotosUI

struct PhotoPickerView: View {
    
    let color: Color = Color.black.opacity(0.7)
    @Binding var selectedImage: ImageDetail
    @State private var showImagePicker = false
    @State private var selectedAsset: PHAsset?
    
    var body: some View {
        VStack {
            Button(action: {
                showImagePicker.toggle()
                selectedAsset = nil
            }) {
                Rectangle()
                    .overlay (
                        Image(systemName: "photo.fill")
                            .foregroundColor(color)
                    )
                    .foregroundColor(.white)
            }
            .cornerRadius(10)
            .aspectRatio(1, contentMode: .fit)
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedAsset: $selectedAsset)
                    .onChange(of: selectedAsset) { newAsset in
                        if let asset = newAsset {
                            loadImage(from: asset)
                        }
                    }
            }
        }
    }
    
    private func loadImage(from asset: PHAsset) {
        let imageManager = PHImageManager.default()
        let imageRequestOptions = PHImageRequestOptions()
        imageRequestOptions.deliveryMode = .highQualityFormat
        imageRequestOptions.isSynchronous = true
        
        imageManager.requestImage(
            for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: imageRequestOptions
        ) { uiImage, _ in
            if let uiImage = uiImage {
                let image = Image(uiImage: uiImage)
                let imageDetail = ImageDetail(image: image, uiImage: uiImage, isValidated: true)
                selectedImage = imageDetail
            } else {
                print("Failed to fetch high-resolution image.")
            }
        }
    }
}

// Custom ImagePicker using PHPhotoLibrary
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedAsset: PHAsset?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.image"]
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let asset = info[.phAsset] as? PHAsset {
                parent.selectedAsset = asset
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

#Preview {
    PhotoPickerView(selectedImage: .constant(ImageDetail(image: Image(systemName: "photo.fill"), uiImage: UIImage(), isValidated: false)))
}
