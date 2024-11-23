import SwiftUI

class UploadPageViewModel: ObservableObject {
    @Published var selectedImage: ImageDetail = ImageDetail()
    
    func resetImage() {
        selectedImage = ImageDetail()
    }
}
