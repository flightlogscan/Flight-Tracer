import SwiftUI

public class ImageDetail: Identifiable, Equatable, ObservableObject {
    
    public static func == (lhs: ImageDetail, rhs: ImageDetail) -> Bool {
        return lhs.id == rhs.id
    }
    
    public var id = UUID()
    
    var image: Image?
    var uiImage: UIImage?
    var imageText: [String] = [] // Basic image text from the simple image scanner
    var validationError: ErrorCode = ErrorCode.NO_ERROR
    var hasError: Bool {
        return validationError != ErrorCode.NO_ERROR
    }
    var isImageLoaded = false
    @Published var hasValidationRun: Bool = false
    @Published var isImageValid: Bool = false
    @Published var recognizedText: [[String]] = [[]] // Advanced image text from the heavy-duty image scanner
    @Published var analyzeResult: AnalyzeResult?
    
    init() {}
    
    init (image: Image, uiImage: UIImage) {
        self.image = image
        self.uiImage = uiImage
        self.isImageLoaded = true
    }
}
