import SwiftUI
import PhotosUI

class PhotoPermissionsManager: NSObject, ObservableObject, PHPhotoLibraryChangeObserver {
    @Published var hasPhotoPermissions = false
    @Published var thumbnailImages: [UIImage] = []
    
    private let imageManager = PHImageManager.default()
    private let fetchOptions: PHFetchOptions
    private let imageRequestOptions: PHImageRequestOptions
    
    override init() {
        fetchOptions = PHFetchOptions()
        imageRequestOptions = PHImageRequestOptions()
        
        super.init()
        
        PHPhotoLibrary.shared().register(self)
        checkPhotoPermissions()
        if hasPhotoPermissions {
            getThumbnailPhotos()
        }
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self) // Unregister when deinitialized
    }
    
    func checkPhotoPermissions() {
        let status = PHPhotoLibrary.authorizationStatus()
        hasPhotoPermissions = (status == .authorized || status == .limited)
    }
    
    func getThumbnailPhotos() {
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 10
        imageRequestOptions.deliveryMode = .highQualityFormat
        imageRequestOptions.isSynchronous = true
        imageRequestOptions.isNetworkAccessAllowed = isICloudAvailable()
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        thumbnailImages = []
        
        fetchResult.enumerateObjects { [weak self] (phAsset, _, _) in
            self?.imageManager.requestImage(
                for: phAsset, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: self?.imageRequestOptions
            ) { (uiImage, _) in
                if let uiImage = uiImage {
                    self?.thumbnailImages.append(uiImage)
                }
            }
        }
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            let currentStatus = PHPhotoLibrary.authorizationStatus()
            let permissionsGranted = (currentStatus == .authorized || currentStatus == .limited)
            
            if permissionsGranted && !self.hasPhotoPermissions {
                self.hasPhotoPermissions = true
                self.getThumbnailPhotos()
            } else if !permissionsGranted {
                self.hasPhotoPermissions = false
            }
        }
    }
    
    func isICloudAvailable() -> Bool {
           // Check if iCloud is available using the FileManager ubiquity container
           return FileManager.default.ubiquityIdentityToken != nil
       }
}
