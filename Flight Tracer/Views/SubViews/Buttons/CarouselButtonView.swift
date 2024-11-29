import SwiftUI

struct CarouselButtonView: View {
    
    @Binding var selectedImage: ImageDetail
    
    var thumbnailImage: UIImage
    var hiResImage: UIImage
    var carouselIndex: Int
    
    var body: some View {
        Button {
            let image = Image(uiImage: hiResImage)
            selectedImage = ImageDetail(image: image, uiImage: hiResImage)
        } label: {
            Image(uiImage: thumbnailImage)
                .resizable()
        }
        .accessibilityIdentifier("carouselButton\(carouselIndex)")
        .cornerRadius(10)
        .aspectRatio(1, contentMode: .fit)
    }
}
