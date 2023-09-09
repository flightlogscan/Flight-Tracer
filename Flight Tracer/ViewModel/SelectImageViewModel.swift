import SwiftUI

class SelectImageViewModel: ObservableObject {
    
    var isImageValid: Bool = false
    let imageTextRecognizer = ImageTextRecognizer()
    let recognizedTextProcessor = RecognizedTextProcessor()
    @Published var recognizedText: [[String]] = [["image data empty"]]
    
    func simpleValidateImage(image: UIImage?) {
        if (image != nil) {
            imageTextRecognizer.scanImageForText(image: image!) { recognizedStrings in
                self.checkBasicFlightLogText(imageText: recognizedStrings)
            }
        } else {
            print("failed")
        }
    }
            
    private func checkBasicFlightLogText(imageText: [String]) {
        isImageValid = imageText.contains { text in
            return text.contains("DATE")
        } && imageText.contains { text in
            return text.contains("CONDITIONS")
        }
    }
}
