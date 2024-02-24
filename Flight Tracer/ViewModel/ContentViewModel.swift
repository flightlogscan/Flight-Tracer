import SwiftUI

class ContentViewModel: ObservableObject {
    
    let formRecognizer = FormRecognizer()
    
    func processImageText(images: [ImageDetail], realScan: Bool? = false, user: User?) {
        for image in images {
            if (realScan!) {
                formRecognizer.scanImage(image: image, user: user)
            }
        }
    }
}
