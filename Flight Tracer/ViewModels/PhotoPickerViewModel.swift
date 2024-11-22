import SwiftUI
import Photos

class PhotoPickerViewModel: ObservableObject {
    
    @Published var selectedImage: ImageDetail?
    @Published var showImagePicker = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var isSheetPresented = false
    @Published var selectedAsset: PHAsset?
    
    func checkPermissionsAndShowPicker() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
            case .authorized, .limited:
                showImagePicker.toggle()
                isSheetPresented = true
                selectedAsset = nil
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                    if newStatus == .authorized || newStatus == .limited {
                        DispatchQueue.main.async {
                            self.showImagePicker.toggle()
                            self.isSheetPresented = true
                            self.selectedAsset = nil
                        }
                    } else {
                        self.showPermissionAlert(forLimitedAccess: false)
                    }
                }
            case .denied, .restricted:
                showPermissionAlert(forLimitedAccess: false)
            @unknown default:
                break
        }
    }

    func handleSelectedAsset(_ asset: PHAsset?) {
        guard let asset = asset else {
            print("No asset selected or accessible.")
            return
        }

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
                self.selectedImage = imageDetail
            } else {
                self.alertMessage = "Failed to load the selected image. Please try again."
                if !self.isSheetPresented {
                    self.showAlert = true
                }
            }
        }
    }
}
