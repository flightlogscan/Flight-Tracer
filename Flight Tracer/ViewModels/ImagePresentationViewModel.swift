import SwiftUI
import Combine

class ImagePresentationViewModel: ObservableObject {
    
    @Published var validationInProgress = false
    @Published var showAlert = false
    @Binding var selectedImage: ImageDetail
    @ObservedObject var simpleImageValidator = SimpleImageValidator()
    
    init() {
    }
    
   
}
