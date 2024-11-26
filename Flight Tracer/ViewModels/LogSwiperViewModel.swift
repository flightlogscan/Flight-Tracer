import SwiftUI

class LogSwiperViewModel: ObservableObject {
    
    let formRecognizer = FormRecognizer()
    
    func processImageText(selectedImage: ImageDetail?, userToken: String, selectedScanType: Int) {
        formRecognizer.scanImage(imageDetail: selectedImage!, userToken: userToken, selectedScanType: selectedScanType)
    }
}
