import SwiftUI

class ContentViewModel: ObservableObject {
    
    let recognizedTextProcessor = RecognizedTextProcessor()
    
    func processImageText(images: [ImageDetail]) {
        for image in images {
            let recognizedText = recognizedTextProcessor.processText(imageText: image.imageText)
            image.recognizedText = recognizedText
            print("recognizedText: \(String(describing: recognizedText))")
        }
    }
}
