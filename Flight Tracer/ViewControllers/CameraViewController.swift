import SwiftUI

struct CameraViewController: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @Binding var selectedImage: ImageDetail

    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = context.coordinator
        return picker
    }
    
    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        var parent: CameraViewController
        
        init(_ parent: CameraViewController) {
            self.parent = parent
        }
        
        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                let image = Image(uiImage: uiImage)
                let imageDetail = ImageDetail(image: image, uiImage: uiImage)

                parent.selectedImage = imageDetail
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
