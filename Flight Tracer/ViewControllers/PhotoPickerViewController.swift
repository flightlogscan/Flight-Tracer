import SwiftUI
import PhotosUI

struct PhotoPickerViewController: UIViewControllerRepresentable {
    @Binding var selectedAsset: PHAsset?
    @Binding var showAlert: Bool
    @Binding var alertMessage: String

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.selectionLimit = 1
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PhotoPickerViewController

        init(_ parent: PhotoPickerViewController) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            guard let result = results.first else {
                parent.alertMessage = "No photo was selected. Please try again."
                parent.showAlert = true
                return
            }

            if let assetId = result.assetIdentifier {
                let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
                if let asset = fetchResult.firstObject {
                    parent.selectedAsset = asset
                } else {
                    parent.alertMessage = "This photo is outside the limited access granted. Please manage photo permissions."
                    parent.showAlert = true
                }
            } else {
                parent.alertMessage = "No asset identifier found. Ensure the app has access to the selected photo."
                parent.showAlert = true
            }

            picker.dismiss(animated: true)
        }
    }
}
