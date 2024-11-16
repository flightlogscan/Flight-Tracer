import SwiftUI
import FirebasePerformance

class SelectImageViewModel: ObservableObject {
    
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
            image.validationResult = ErrorCode.MAX_SIZE_EXCEEDED
            return
        }
        
        imageTextRecognizer.scanImageForText(image: image.uiImage!) { recognizedStrings in
            image.imageText = recognizedStrings
            let isImageValid = self.checkBasicFlightLogText(imageText: recognizedStrings)
            image.isImageValid = isImageValid
            if (isImageValid == false) {
                trace?.incrementMetric("NoRecognizedText", by: 1)
                image.validationResult = ErrorCode.NO_RECOGNIZED_TEXT
            } else {
                trace?.incrementMetric("Success", by: 1)
            }
            trace?.stop()
        }
    }
            
    private func checkBasicFlightLogText(imageText: [String]) -> Bool {
        let containsDate = imageText.contains { text in
            return text.contains("DATE")
        }
        
        let containsConditions = imageText.contains { text in
            return text.contains("CONDITIONS")
        }

        return containsDate && containsConditions
    }
}
