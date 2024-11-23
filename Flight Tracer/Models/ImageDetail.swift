import SwiftUI

public class ImageDetail: Identifiable, Equatable, ObservableObject {
    
    public static func == (lhs: ImageDetail, rhs: ImageDetail) -> Bool {
        return lhs.id == rhs.id
    }
    
    public var id = UUID()
    
    var image: Image?
    var uiImage: UIImage?
    @Published var isValidated: Bool?
    var validationError: ErrorCode?
    @Published var isImageValid: Bool?
    var imageText: [String] = [] // Basic image text from the simple image scanner
    @Published var recognizedText: [[String]] = [[]] // Advanced image text from the heavy-duty image scanner
    @Published var analyzeResult: AnalyzeResult?
    
    init() {}
    
    init (image: Image, uiImage: UIImage, isValidated: Bool, analyzeResult: AnalyzeResult? = nil) {
        self.image = image
        self.uiImage = uiImage
        self.isValidated = isValidated
        self.analyzeResult = analyzeResult
    }
}
