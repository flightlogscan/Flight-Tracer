import SwiftUI

class LogSwiperViewModel: ObservableObject {
    
    let formRecognizer = FormRecognizer()
    
    func processImageText(selectedImage: ImageDetail?, realScan: Bool? = false, userToken: String, selectedScanType: Int) {
        if (realScan!) {
            formRecognizer.scanImage(imageDetail: selectedImage!, userToken: userToken, selectedScanType: selectedScanType)
        } else {
            print("Not a real scan!")
        }
    }
}
