import SwiftUI
import Mantis

struct CropperViewController: UIViewControllerRepresentable {
    @Binding var selectedImage: ImageDetail
    @Environment(\.presentationMode) var presentationMode
   
   func makeUIViewController(context: Context) -> CropViewController {
       let cropViewController = Mantis.cropViewController(image: selectedImage.uiImage!)
       cropViewController.delegate = context.coordinator
       return cropViewController
   }
   
   func updateUIViewController(_ uiViewController: CropViewController, context: Context) {}
   
   func makeCoordinator() -> Coordinator {
       Coordinator(self)
   }
   
   class Coordinator: CropViewControllerDelegate {
       var parent: CropperViewController
       
       init(_ parent: CropperViewController) {
           self.parent = parent
       }
       
       func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation, cropInfo: CropInfo) {
           
           let image = Image(uiImage: cropped)
           let imageDetail = ImageDetail(image: image, uiImage: cropped)
           parent.selectedImage = imageDetail
           parent.presentationMode.wrappedValue.dismiss()
       }
       
       func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
           parent.presentationMode.wrappedValue.dismiss()
       }
   }
}
