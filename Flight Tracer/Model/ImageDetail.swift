import SwiftUI

public class ImageDetail: Identifiable, Equatable, ObservableObject {
    
    public static func == (lhs: ImageDetail, rhs: ImageDetail) -> Bool {
        return lhs.id == rhs.id
    }
    
    public var id = UUID()
    
    var image: Image
    var uiImage: UIImage
    var isValidated: Bool // TODO: Is this field used for anything anymore?
    var isImageValid: Bool
    var imageText: [String] // Basic image text from the simple image scanner
    var recognizedText: [[String]] // Advanced image text from the heavy-duty image scanner
    @Published var analyzeResult: AnalyzeResult?
    
    init (image: Image, uiImage: UIImage, isValidated: Bool, analyzeResult: AnalyzeResult? = nil) {
        self.image = image
        self.uiImage = uiImage
        self.isValidated = isValidated
        self.isImageValid = false
        self.imageText = []
        self.recognizedText = [[]]
        self.analyzeResult = analyzeResult
    }
}
