import SwiftUI
import PhotosUI

let imageManager = PHImageManager.default()
let fetchOptions = PHFetchOptions()
let imageRequestOptions = PHImageRequestOptions()

struct PhotoCarouselView: View {
    @State var thumbnailImages:[UIImage] = []
    @Binding var selectedImage: ImageDetail
    @Binding var selectedItem: PhotosPickerItem?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [GridItem()]) {
                CameraView(selectedImage: $selectedImage)
                
                ForEach(0..<thumbnailImages.count, id: \.self) { index in
                    CarouselButtonView(thumbnailImage: thumbnailImages[index], hiResImage: getImage(index: index), selectedImage: $selectedImage)
                }
                
                PhotoPickerView(selectedItem: $selectedItem, selectedImage: $selectedImage)
            }
        }
        .frame(height: 75)
        .padding([.leading, .trailing])
        .onAppear {
            getThumbnailPhotos()
        }
        .onReceive(NotificationCenter.default.publisher(
            for: UIScene.willEnterForegroundNotification)) { _ in
                // Refresh photo carousel when app is back in focus in case anything changed
                // Slow, but it works..
                getThumbnailPhotos()
                
        }
        .shadow(radius: 1)
    }
    
    func getThumbnailPhotos() {
        //This code is gross and needs to be extracted to a different class
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 10
        
        imageRequestOptions.deliveryMode = .highQualityFormat
        imageRequestOptions.isSynchronous = true
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        thumbnailImages = []
        
        fetchResult.enumerateObjects { (phAsset, _, _) in
            imageManager.requestImage(
                for: phAsset, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: imageRequestOptions
            ) { (uiImage, _) in
                thumbnailImages.append(uiImage!)
            }
        }
    }
    
    // This code is gross and needs to be extracted to a different class
    // There is a bug where if a photo is added or deleted in the photos app, FLT won't
    // know to update the index and thus show incorrect images.
    func getImage(index: Int) -> UIImage {
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        let asset: PHAsset = fetchResult.object(at: index)
        
        var image: UIImage?
        imageManager.requestImage(
            for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: imageRequestOptions
        ) { (uiImage, _) in
            image = uiImage
        }
        
      return image!
    }
}



#Preview {
    UploadPageView(user: Binding.constant(nil))
}
