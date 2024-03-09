import SwiftUI

class SelectImageViewModel: ObservableObject {
    
    let imageTextRecognizer = ImageTextRecognizer()
    @Published var recognizedText: [[String]] = [["image data empty"]]
    
    func simpleValidateImage(image: ImageDetail?) {
        if (image != nil) {
            //image!.isImageValid = true
            sleep(1)
            print("simple validate image")
            imageTextRecognizer.scanImageForText(image: image!.uiImage) { recognizedStrings in
                image!.imageText = recognizedStrings
                image!.isImageValid = self.checkBasicFlightLogText(imageText: recognizedStrings)
            }
        } else {
            print("failed")
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
