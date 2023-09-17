import SwiftUI

public class ImageDetail: Identifiable {
    public var id = UUID()
    
    var image: Image
    var uiImage: UIImage
    var isValidated: Bool // TODO: Is this field used for anything anymore?
    var isImageValid: Bool
    var imageText: [String] // Basic image text from the simple image scanner
    var recognizedText: [[String]] // Advanced image text from the heavy-duty image scanner
    
    init (image: Image, uiImage: UIImage, isValidated: Bool) {
        self.image = image
        self.uiImage = uiImage
        self.isValidated = isValidated
        self.isImageValid = false
        self.imageText = []
        self.recognizedText = [[]]
    }
}
