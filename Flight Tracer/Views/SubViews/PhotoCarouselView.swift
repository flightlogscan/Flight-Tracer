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
        
        PHPhotoLibrary.shared().register(self) // Register for photo library changes
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
}

struct PhotoCarouselView: View {
    @StateObject private var photoPermissionsManager = PhotoPermissionsManager()
    @Binding var selectedImage: ImageDetail
    @Binding var selectedItem: PhotosPickerItem?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [GridItem()]) {
                CameraView(selectedImage: $selectedImage)
                                
                ForEach(0..<photoPermissionsManager.thumbnailImages.count, id: \.self) { index in
                    CarouselButtonView(thumbnailImage: photoPermissionsManager.thumbnailImages[index], hiResImage: getImage(index: index), selectedImage: $selectedImage)
                }
                
                if !photoPermissionsManager.hasPhotoPermissions {
                    CarouselSkeleton()
                    CarouselSkeleton()
                    CarouselSkeleton()
                }
                
                PhotoPickerView(selectedImage: $selectedImage)
            }
        }
        .frame(height: 75)
        .padding([.leading, .trailing])
        .shadow(radius: 1)
        .onChange(of: photoPermissionsManager.hasPhotoPermissions) { newValue in
            if newValue {
                photoPermissionsManager.getThumbnailPhotos()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIScene.willEnterForegroundNotification)) { _ in
            photoPermissionsManager.getThumbnailPhotos()
        }
    }
    
    private func getImage(index: Int) -> UIImage {
        photoPermissionsManager.thumbnailImages[index]
    }
}
