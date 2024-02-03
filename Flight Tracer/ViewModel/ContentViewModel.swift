import SwiftUI

class ContentViewModel: ObservableObject {
    
    let recognizedTextProcessor = RecognizedTextProcessor()
    let formRecognizer = FormRecognizer()
    
    func processImageText(images: [ImageDetail], realScan: Bool? = false, user: User?) {
        for image in images {
            let recognizedText = recognizedTextProcessor.processText(imageText: image.imageText)
            image.recognizedText = recognizedText
            print("recognizedText: \(String(describing: recognizedText))")
            
            if (realScan!) {
                formRecognizer.scanImage(image: image, user: user)
            }
        }
    }
}
