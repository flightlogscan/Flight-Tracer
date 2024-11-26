import SwiftUI
import FirebasePerformance

class SimpleImageScanner {
    
    let imageTextRecognizer = ImageTextRecognizer()
    
    func simpleImageScan(image: ImageDetail) -> SimpleImageScanResult {
        let data = image.uiImage!.jpegData(compressionQuality: 1.0)!
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = ByteCountFormatter.Units.useKB
        formatter.countStyle = ByteCountFormatter.CountStyle.file
        
        let trace = Performance.startTrace(name: "BasicImageValidation")
        
        if (data.count/1000 > 10000) {
            trace?.incrementMetric("InvalidSize", by: 1)
            trace?.stop()
            return SimpleImageScanResult(isImageValid: false, validationError: ErrorCode.MAX_SIZE_EXCEEDED)
        }
        
        var simpleImageScanResult: SimpleImageScanResult!
        
        imageTextRecognizer.scanImageForText(image: image.uiImage!) { recognizedStrings in
            let isImageValid = self.checkBasicFlightLogText(imageText: recognizedStrings)
            if (!isImageValid) {
                trace?.incrementMetric("NoRecognizedText", by: 1)
                simpleImageScanResult = SimpleImageScanResult(isImageValid: false, validationError: ErrorCode.NO_RECOGNIZED_TEXT)
            } else {
                trace?.incrementMetric("Success", by: 1)
                simpleImageScanResult = SimpleImageScanResult(isImageValid: true, validationError: ErrorCode.NO_ERROR, imageText: recognizedStrings)
            }
        }
        
        trace?.stop()
        return simpleImageScanResult
    }
            
    // Hardcoded to check for Jeppesen fields
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
