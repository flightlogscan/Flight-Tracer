import SwiftUI
import FirebasePerformance

class SimpleImageScanner {
    
    let imageTextRecognizer = ImageTextRecognizer()
    
    func simpleImageScan(image: UIImage) async throws -> SimpleImageScanResult {
        let data = image.jpegData(compressionQuality: 0.8)!
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = ByteCountFormatter.Units.useKB
        formatter.countStyle = ByteCountFormatter.CountStyle.file
        
        let trace = Performance.startTrace(name: "BasicImageValidation")
        
        let imageSizeKB = Double(data.count) / 1024.0
        print("imagesizekb = \(imageSizeKB)")

        if (imageSizeKB > 4096) {
            
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
