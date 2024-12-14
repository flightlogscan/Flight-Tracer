import SwiftUI

class LogSwiperViewModel: ObservableObject {
    
    @Published var isImageValid: Bool = false
    @Published var alertMessage = ErrorCode.NO_ERROR.message
    @Published var showAlert: Bool = false
    @Published var rowViewModels: [LogRowViewModel] = []
    
    let advancedImageScanner = AdvancedImageScanner()
    let logTextRefiner = LogTextRefiner()
    //TODO: Eventually needs to allow dynamic selection of log format. Hardcoded to Jeppesen currently.
    let logFieldMetadata = LogMetadataLoader.getLogMetadata(named: "JeppesenLogFormat")
    
    func scanImageForLogText(uiImage: UIImage, userToken: String, selectedScanType: ScanType) {
        Task {
            
            //Reset validation before new scan
            await MainActor.run {
                rowViewModels = []
                isImageValid = false
                alertMessage = ErrorCode.NO_ERROR.message
                showAlert = false
            }
            
            do {
                let advancedImageScanResult = try await advancedImageScanner.analyzeImageAsync(uiImage: uiImage, userToken: userToken, selectedScanType: selectedScanType)
            
                await MainActor.run {
                    isImageValid = advancedImageScanResult.isImageValid
                    alertMessage = advancedImageScanResult.errorCode.message
                    
                    if let result = advancedImageScanResult.analyzeResult {
                        let unrefinedTextArray = convertToArray(analyzeResult: result, logFieldMetadata: logFieldMetadata)
                        
                        let logTextArray = logTextRefiner.refineLogText(
                            unrefinedLogText: unrefinedTextArray,
                            logFieldMetadata: logFieldMetadata
                        )
                                                
                        rowViewModels = logTextArray.map { LogRowViewModel(fields: $0) }
                    }
                }
            } catch {
                await MainActor.run {
                    isImageValid = false
                    alertMessage = ErrorCode.SERVER_ERROR.message
                    showAlert = true
                }
            }
        }
    }
}
