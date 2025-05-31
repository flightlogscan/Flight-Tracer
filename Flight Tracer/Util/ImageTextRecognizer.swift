import Foundation
import Vision
import VisionKit

// TODO: Potentially needs real UI error handling to let user know of image scan error?
struct ImageTextRecognizer {
    typealias TextRecognitionCompletion = ([String]) -> Void
    
    func scanImageForText(image: UIImage, completion: @escaping TextRecognitionCompletion) {
        guard let cgImage = image.cgImage else {
            completion(["no cgImage"])
            return
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest(completionHandler: { request, error in
            var recognizedStrings: [String] = []
            
            if let observations = request.results as? [VNRecognizedTextObservation] {
                // Get the recognized text from the observations.
                recognizedStrings = observations.compactMap { observation in
                    observation.topCandidates(1).first?.string
                }
            } else {
                print("Failed to recognize text.")
            }
            
            // Pass the recognized text back to the caller using the completion handler.
            completion(recognizedStrings)
        })
        
        request.usesLanguageCorrection = true
        
        do {
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
            completion(["unable to perform request"])
        }
    }
}
