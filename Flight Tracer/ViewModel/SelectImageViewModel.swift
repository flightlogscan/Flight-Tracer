import SwiftUI

class SelectImageViewModel: ObservableObject {
    
    let imageTextRecognizer = ImageTextRecognizer()
    @Published var recognizedText: [[String]] = [["image data empty"]]
    
    func simpleValidateImage(image: ImageDetail) {
        if (image != nil) {

            let data = image.uiImage!.jpegData(compressionQuality: 1.0)!
            let formatter = ByteCountFormatter()
            formatter.allowedUnits = ByteCountFormatter.Units.useKB
            formatter.countStyle = ByteCountFormatter.CountStyle.file
            let imageSizeKBString = formatter.string(fromByteCount: Int64(data.count))
            print("ImageSize(KB): \(imageSizeKBString)")
            
            // TODO: Decrease this limit to 4MB
            if (data.count/1000 > 10000) {
                image.isImageValid = false
                image.validationResult = "Image is too large"
                return
            }
            
            imageTextRecognizer.scanImageForText(image: image.uiImage!) { recognizedStrings in
                image.imageText = recognizedStrings
                let isImageValid = self.checkBasicFlightLogText(imageText: recognizedStrings)
                image.isImageValid = isImageValid
                if (isImageValid == false) {
                    image.validationResult = "Image has no recognized text"
                }
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
