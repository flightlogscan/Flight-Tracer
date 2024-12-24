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
            
    // TODO: Expand to accept support other log types. Currently hardcoded to check for Jeppesen fields.
    private func checkBasicFlightLogText(imageText: [String]) -> Bool {
        
        //DATE is on the left page of the Jeppesen log
        let containsDate = imageText.contains { text in
            return text.contains("DATE")
        }
        
        //CONDITIONS is on the right page of the Jeppesen log
        let containsConditions = imageText.contains { text in
            return text.contains("CONDITIONS")
        }

        return containsDate && containsConditions
    }
}
