import SwiftUI

class ContentViewModel: ObservableObject {
    
    let formRecognizer = FormRecognizer()
    
    func processImageText(selectedImage: ImageDetail?, realScan: Bool? = false, user: User?, selectedScanType: Int) {
        if (realScan!) {
            // Scan the image and get the raw "AnalyzeResult"
            formRecognizer.scanImage(image: selectedImage!, user: user, selectedScanType: selectedScanType)
            
            // Convert the raw "AnalyzeResult" to a more usable and sanitized "recognizedText"
//            selectedImage!.recognizedText = convertTo2DArray(analyzeResult: selectedImage!.analyzeResult!, headers: headers)
        }
    }
}
