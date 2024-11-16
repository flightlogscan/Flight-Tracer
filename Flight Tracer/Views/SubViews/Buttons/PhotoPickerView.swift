import SwiftUI
import Photos
import PhotosUI

struct PhotoPickerView: View {
    let color: Color = Color.black.opacity(0.7)
    @Binding var selectedImage: ImageDetail
    @State private var showImagePicker = false
    @State private var selectedAsset: PHAsset?
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isSheetPresented = false

    var body: some View {
        VStack {
            Button(action: {
                checkPermissionsAndShowPicker()
            }) {
                Rectangle()
                    .overlay(
                        Image(systemName: "photo.fill")
                            .foregroundColor(color)
                    )
                    .foregroundColor(.white)
            }
            .cornerRadius(10)
            .aspectRatio(1, contentMode: .fit)
            .sheet(isPresented: $showImagePicker, onDismiss: {
                // Reset `isSheetPresented` when the sheet is dismissed
                isSheetPresented = false
            }) {
                ImagePicker(selectedAsset: $selectedAsset, showAlert: $showAlert, alertMessage: $alertMessage)
                    .onChange(of: selectedAsset) { newAsset in
                        handleSelectedAsset(newAsset)
                    }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Photo Access Issue"),
                    message: Text(alertMessage),
                    primaryButton: .default(Text("Go to Settings")) {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                        }
                    },
                    secondaryButton: .cancel(Text("OK"))
                )
            }
        }
    }

    private func checkPermissionsAndShowPicker() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
        case .authorized, .limited:
            showImagePicker.toggle()
            isSheetPresented = true  // Mark the sheet as presented
            selectedAsset = nil
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                if newStatus == .authorized || newStatus == .limited {
                    DispatchQueue.main.async {
                        showImagePicker.toggle()
                        isSheetPresented = true
                        selectedAsset = nil
                    }
                } else {
                    showPermissionAlert(forLimitedAccess: false)
                }
            }
        case .denied, .restricted:
            showPermissionAlert(forLimitedAccess: false)
        @unknown default:
            break
        }
    }

    private func handleSelectedAsset(_ asset: PHAsset?) {
        guard let asset = asset else {
            print("No asset selected or accessible.")
            return
        }

        // Check if the asset is accessible
        let assetResources = PHAssetResource.assetResources(for: asset)
        if assetResources.isEmpty {
            showPermissionAlert(forLimitedAccess: true)
        } else {
            loadImage(from: asset)
        }
    }

    private func showPermissionAlert(forLimitedAccess: Bool) {
        alertMessage = forLimitedAccess
            ? "This photo is outside the limited access you have granted. You can manage access to more photos."
            : "Please grant photo library access in Settings to use this feature."
    
        // Show the alert and add a button to open Settings if needed
        if !isSheetPresented {
            showAlert = true
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
                alertMessage = "Failed to load the selected image. Please try again."
                if !isSheetPresented {
                    showAlert = true
                }
            }
        }
    }
}

// Updated ImagePicker using PHPickerViewController
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedAsset: PHAsset?
    @Binding var showAlert: Bool
    @Binding var alertMessage: String

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.selectionLimit = 1  // Allow selecting only one photo
        config.filter = .images   // Limit to images only

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
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

// Preview
#Preview {
    PhotoPickerView(selectedImage: .constant(ImageDetail(image: Image(systemName: "photo.fill"), uiImage: UIImage(), isValidated: false)))
}
