import SwiftUI
import FirebasePerformance

class SimpleImageValidator: ObservableObject {
    
    let imageTextRecognizer = ImageTextRecognizer()
    @Published var recognizedText: [[String]] = [["image data empty"]]
    
    func simpleValidateImage(image: ImageDetail) {
        let data = image.uiImage!.jpegData(compressionQuality: 1.0)!
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = ByteCountFormatter.Units.useKB
        formatter.countStyle = ByteCountFormatter.CountStyle.file
        
        let trace = Performance.startTrace(name: "BasicImageValidation")
        
        if (data.count/1000 > 10000) {
            trace?.incrementMetric("InvalidSize", by: 1)
            trace?.stop()
            image.isImageValid = false
            image.validationError = ErrorCode.MAX_SIZE_EXCEEDED
            return
        }
        
        imageTextRecognizer.scanImageForText(image: image.uiImage!) { recognizedStrings in
            image.imageText = recognizedStrings
            let isImageValid = self.checkBasicFlightLogText(imageText: recognizedStrings)
            image.isImageValid = isImageValid
            if (isImageValid == false) {
                trace?.incrementMetric("NoRecognizedText", by: 1)
                image.validationError = ErrorCode.NO_RECOGNIZED_TEXT
            } else {
                trace?.incrementMetric("Success", by: 1)
            }
            trace?.stop()
        }
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
