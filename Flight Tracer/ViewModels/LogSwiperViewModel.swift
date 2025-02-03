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
    
    @Published var debugRowCount: Int = 0
    
    func scanImageForLogText(uiImage: UIImage, userToken: String, selectedScanType: ScanType) {
        Task {
            await MainActor.run {
                rowViewModels = []
                isImageValid = false
                alertMessage = ErrorCode.NO_ERROR.message
                showAlert = false
                debugRowCount = 0 // Reset counter
            }
            
            do {
                let advancedImageScanResult = try await advancedImageScanner.analyzeImageAsync(uiImage: uiImage, userToken: userToken, selectedScanType: selectedScanType)
                
                await MainActor.run {
                    isImageValid = advancedImageScanResult.isImageValid
                    alertMessage = advancedImageScanResult.errorCode.message
                    
                    if let result = advancedImageScanResult.analyzeResult {
                        let unrefinedTextArray = convertToArray(
                            analyzeResult: result,
                            logFieldMetadata: logFieldMetadata,
                            tables: advancedImageScanResult.tables!
                        )
                        print("unrefined text array: ")
                        print(unrefinedTextArray)
                        debugRowCount = unrefinedTextArray.count
                        
                        let logTextArray = logTextRefiner.refineLogText(
                            unrefinedLogText: unrefinedTextArray,
                            logFieldMetadata: logFieldMetadata
                        )
                        
                        print("logTextArray: ")
                        print(logTextArray)
                        print("Row count after refinement: \(logTextArray.count)")
                        
                        rowViewModels = logTextArray.enumerated().map { index, fields in
                            let vm = LogRowViewModel(fields: fields)
                            print("Created ViewModel for row \(index): \(fields.count) fields")
                            return vm
                        }
                        print("Final rowViewModels count: \(rowViewModels.count)")
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
