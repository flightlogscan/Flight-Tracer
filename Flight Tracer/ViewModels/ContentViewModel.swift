import SwiftUI

class ContentViewModel: ObservableObject {
    
    let formRecognizer = FormRecognizer()
    
    func processImageText(selectedImage: ImageDetail?, realScan: Bool? = false, user: User?, selectedScanType: Int) {
        if (realScan!) {
            formRecognizer.scanImage(imageDetail: selectedImage!, user: user, selectedScanType: selectedScanType)
        } else {
            print("Not a real scan!")
        }
    }
}
