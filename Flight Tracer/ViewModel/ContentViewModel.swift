import SwiftUI

class ContentViewModel: ObservableObject {
    
    let formRecognizer = FormRecognizer()
    
    func processImageText(selectedImage: ImageDetail?, realScan: Bool? = false, user: User?, selectedScanType: Int) {
        if (realScan!) {
            formRecognizer.scanImage(image: selectedImage!, user: user, selectedScanType: selectedScanType)
        }
    }
}
