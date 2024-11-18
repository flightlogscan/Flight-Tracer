import SwiftUI

class UploadPageViewModel: ObservableObject {
    @Published var selectedImage: ImageDetail = ImageDetail()
    
    func resetAnalyzeResult() {
        selectedImage = ImageDetail()
    }
}
