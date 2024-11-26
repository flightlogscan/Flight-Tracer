import SwiftUI

class UploadPageViewModel: ObservableObject {
    @Published var selectedImage: ImageDetail = ImageDetail()
    @Published var isImageValid: Bool = false
    @Published var alertMessage = ErrorCode.NO_ERROR.message
    @Published var validationInProgress: Bool = false
    @Published var showAlert: Bool = false
    
    let simpleImageValidator = SimpleImageScanner()

    func resetImage() {
        selectedImage = ImageDetail()
        isImageValid = false
    }
    
    func simpleValidateImage() async {
        // If image is already being validated, skip
        guard !validationInProgress else { return }
        
        // Reset validation state before starting the new validation
        await MainActor.run {
            validationInProgress = true
            isImageValid = false
        }

        do {
            let scanResult = try await validateImageAsync(imageDetail: selectedImage)
            
            await MainActor.run {
                isImageValid = scanResult.isImageValid
                alertMessage = scanResult.validationError.message
                
                if let text = scanResult.imageText {
                    selectedImage.imageText = text
                }
                
                selectedImage.validationError = scanResult.validationError
                validationInProgress = false
                showAlert = alertMessage != ErrorCode.NO_ERROR.message
            }
        } catch {
            await MainActor.run {
                alertMessage = ErrorCode.TRANSIENT_FAILURE.message
                isImageValid = false
                validationInProgress = false
                showAlert = true
            }
        }
    }
    
    /// Converts the synchronous scanner logic to asynchronous
    private func validateImageAsync(imageDetail: ImageDetail) async throws -> SimpleImageScanResult {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let result = self.simpleImageValidator.simpleImageScan(image: imageDetail)
                continuation.resume(returning: result)
            }
        }
    }
}
