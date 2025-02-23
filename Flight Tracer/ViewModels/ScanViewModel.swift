import SwiftUI

class ScanViewModel: ObservableObject {
    
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
            let simpleScanResult = try await simpleImageValidator.simpleImageScan(image: self.selectedImage.uiImage!)
            
            await MainActor.run {
                isImageValid = simpleScanResult.isImageValid
                alertMessage = simpleScanResult.errorCode.message
                
                if let text = simpleScanResult.imageText {
                    selectedImage.imageText = text
                }
                
                selectedImage.validationError = simpleScanResult.errorCode
                validationInProgress = false
                showAlert = alertMessage != ErrorCode.NO_ERROR.message
            }
        } catch {
            await MainActor.run {
                alertMessage = ErrorCode.SERVER_ERROR.message
                isImageValid = false
                validationInProgress = false
                showAlert = true
            }
        }
    }
}
