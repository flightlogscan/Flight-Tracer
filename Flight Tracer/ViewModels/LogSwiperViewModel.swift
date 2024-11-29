import SwiftUI

class LogSwiperViewModel: ObservableObject {
    
    @Published var logText: [[String]] = []
    @Published var isImageValid: Bool = false
    @Published var alertMessage = ErrorCode.NO_ERROR.message
    @Published var showAlert: Bool = false
    
    let advancedImageScanner = AdvancedImageScanner()
    let logTextRefiner = LogTextRefiner()
    //TODO: Eventually needs to allow dynamic selection of log format. Hardcoded to Jeppesen currently.
    let logFieldMetadata = LogMetadataLoader.getLogMetadata(named: "JeppesenLogFormat")
    
    func scanImageForLogText(uiImage: UIImage, userToken: String, selectedScanType: ScanType) {
        Task {
            
            //Reset validation before new scan
            await MainActor.run {
                logText = []
                isImageValid = false
                alertMessage = ErrorCode.NO_ERROR.message
                showAlert = false
            }
            
            do {
                let advancedImageScanResult = try await advancedImageScanner.analyzeImageAsync(uiImage: uiImage, userToken: userToken, selectedScanType: selectedScanType)
            
                await MainActor.run {
                    self.isImageValid = advancedImageScanResult.isImageValid
                    self.alertMessage = advancedImageScanResult.errorCode.message
                    
                    if let result = advancedImageScanResult.analyzeResult {
                        let unrefinedTextArray = convertToArray(analyzeResult: result, logFieldMetadata: self.logFieldMetadata)
                        
                        let refinedTextArray = self.logTextRefiner.refineLogText(
                            unrefinedLogText: unrefinedTextArray,
                            logFieldMetadata: self.logFieldMetadata
                        )
                        
                        self.logText = refinedTextArray
                    }
                    
                    
                }
            } catch {
                await MainActor.run {
                    self.isImageValid = false
                    self.alertMessage = ErrorCode.SERVER_ERROR.message
                    self.showAlert = true
                }
            }
        }
    }
}
