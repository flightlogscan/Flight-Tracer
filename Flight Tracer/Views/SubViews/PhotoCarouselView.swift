import SwiftUI
import PhotosUI

let imageManager = PHImageManager.default()
let fetchOptions = PHFetchOptions()
let imageRequestOptions = PHImageRequestOptions()

struct PhotoCarouselView: View {
    @State var thumbnailImages:[UIImage] = []
    @Binding var selectedImages: [ImageDetail]
    @Binding var selectedItem: PhotosPickerItem?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [GridItem()]) {
                CameraView(selectedImages: $selectedImages)
                
                ForEach(0..<thumbnailImages.count, id: \.self) { index in
                    CarouselButtonView(thumbnailImage: thumbnailImages[index], hiResImage: getImage(index: index), selectedImages: $selectedImages)
                }
                
                PhotoPickerView(selectedItem: $selectedItem, selectedImages: $selectedImages)
            }
        }
        //.border(.red)
        .frame(height: 75)
        .padding([.leading, .trailing])
        .onAppear {
            //This code is gross and needs to be extracted to a different class
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            fetchOptions.fetchLimit = 10
            
            imageRequestOptions.deliveryMode = .highQualityFormat
            imageRequestOptions.isSynchronous = true
            
            let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            
            fetchResult.enumerateObjects { (phAsset, _, _) in
                imageManager.requestImage(
                    for: phAsset, targetSize: CGSize(width: 1280, height: 768), contentMode: .default, options: imageRequestOptions
                ) { (uiImage, _) in
                    thumbnailImages.append(uiImage!)
                }
            }
        }
    }
    
    //This code is gross and needs to be extracted to a different class
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
    FlightLogUploadView(user: Binding.constant(nil))
}
