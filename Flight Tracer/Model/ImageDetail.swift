import SwiftUI

public class ImageDetail: Identifiable, Equatable, ObservableObject {
    
    public static func == (lhs: ImageDetail, rhs: ImageDetail) -> Bool {
        return lhs.id == rhs.id
    }
    
    public var id = UUID()
    
    var image: Image? = nil
    var uiImage: UIImage? = nil
    @Published var isValidated: Bool? = nil
    var validationResult: ErrorCode? = nil
    @Published var isImageValid: Bool? = nil
    var imageText: [String] // Basic image text from the simple image scanner
    var recognizedText: [[String]] // Advanced image text from the heavy-duty image scanner
    @Published var analyzeResult: AnalyzeResult?
    
    init() {
        self.image = nil
        self.uiImage = nil
        self.isValidated = nil
        self.isImageValid = nil
        self.imageText = []
        self.recognizedText = [[]]
        self.analyzeResult = analyzeResult
    }
    
    init (image: Image, uiImage: UIImage, isValidated: Bool, analyzeResult: AnalyzeResult? = nil) {
        self.image = image
        self.uiImage = uiImage
        self.isValidated = isValidated
        self.isImageValid = nil
        self.imageText = []
        self.recognizedText = [[]]
        self.analyzeResult = analyzeResult
    }
}
