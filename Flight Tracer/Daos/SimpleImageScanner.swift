import SwiftUI
import FirebasePerformance

class SimpleImageScanner {
    
    // API requires images <= 4MB
    let MAX_SIZE_IN_BYTES = Int(4.0 * 1024 * 1024)
    
    // Arbitrarily decided minimum quality (can adjust in future if needed)
    let MIN_QUALITY = 0.8
    
    let imageTextRecognizer = ImageTextRecognizer()
    
    func simpleImageScan(image: UIImage) async throws -> SimpleImageScanResult {
        let trace = Performance.startTrace(name: "BasicImageValidation")

        var compressionQuality = 1.0
        var originalImageData = image.jpegData(compressionQuality: compressionQuality)!
        var newImageData = originalImageData

        print ("initial image size: \(Double(newImageData.count) / 1024 / 1024)")
        while newImageData.count > MAX_SIZE_IN_BYTES && compressionQuality >= MIN_QUALITY {

            compressionQuality -= 0.05

            newImageData = image.jpegData(compressionQuality: compressionQuality)!

            print("Compressed to quality: \(compressionQuality), size: \(Double(newImageData.count) / 1024 / 1024)MB")
        }
        
        originalImageData = newImageData
        
        print ("Final compressionQuality: \(compressionQuality)")
        
        // If we compress and are still too big, error.
        if (originalImageData.count > MAX_SIZE_IN_BYTES) {
            trace?.incrementMetric("InvalidSize", by: 1)
            trace?.stop()
            return SimpleImageScanResult(isImageValid: false, errorCode: ErrorCode.MAX_SIZE_EXCEEDED)
        }
        
        var simpleImageScanResult: SimpleImageScanResult!
        
        imageTextRecognizer.scanImageForText(image: image) { recognizedStrings in
            let isImageValid = self.checkBasicFlightLogText(imageText: recognizedStrings)
            if (!isImageValid) {
                trace?.incrementMetric("NoRecognizedText", by: 1)
                simpleImageScanResult = SimpleImageScanResult(isImageValid: false, errorCode: ErrorCode.NO_RECOGNIZED_TEXT)
            } else {
                trace?.incrementMetric("Success", by: 1)
                simpleImageScanResult = SimpleImageScanResult(isImageValid: true, errorCode: ErrorCode.NO_ERROR, imageText: recognizedStrings)
            }
        }
        
        trace?.stop()
        return simpleImageScanResult
    }
    
    // Filter out non-logbooks before allowing scan.
    // Most logbooks contain these words, if we find some that don't, we can update it.
    private func checkBasicFlightLogText(imageText: [String]) -> Bool {
        return imageText.contains { text in
            let lowercasedText = text.lowercased()
            return lowercasedText.contains("flight") || lowercasedText.contains("aircraft")
        }
    }
}
