import SwiftUI

class ContentViewModel: ObservableObject {
    
    let recognizedTextProcessor = RecognizedTextProcessor()
    @Published var recognizedText: [[String]] = [["image data empty"]]
    
    func processImageText(imageText: [String]) {
        self.recognizedText = recognizedTextProcessor.processText(imageText: imageText)
        print("recognizedText: \(String(describing: self.recognizedText))")
    }
}
