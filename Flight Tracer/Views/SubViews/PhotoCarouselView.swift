import SwiftUI
import PhotosUI

struct PhotoCarouselView: View {
    @StateObject private var photoPermissionsManager = PhotoPermissionsManager()
    @Binding var selectedImage: ImageDetail
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [GridItem()]) {
                CameraView(selectedImage: $selectedImage)
                                
                ForEach(0..<photoPermissionsManager.thumbnailImages.count, id: \.self) { index in
                    CarouselButtonView(
                        thumbnailImage: photoPermissionsManager.thumbnailImages[index],
                        hiResImage: photoPermissionsManager.thumbnailImages[index],
                        selectedImage: $selectedImage
                    )
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
}
