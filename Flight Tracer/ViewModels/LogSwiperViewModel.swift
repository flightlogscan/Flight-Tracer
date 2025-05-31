import SwiftUI

class LogSwiperViewModel: ObservableObject {
    @Published var isImageValid: Bool = false
    @Published var alertMessage = ErrorCode.NO_ERROR.message
    @Published var showAlert: Bool = false
    @Published var editableLog: EditableLog? = nil
    
    let advancedImageScanner = AdvancedImageScanner()
    
    func scanImageForLogText(uiImage: UIImage, userToken: String, selectedScanType: ScanType) {
        Task {
            await MainActor.run {
                isImageValid = false
                alertMessage = ErrorCode.NO_ERROR.message
                showAlert = false
            }
            
            do {
                let scanResult = try await advancedImageScanner.analyzeImageAsync(
                    uiImage: uiImage,
                    userToken: userToken,
                    selectedScanType: selectedScanType
                )
                
                await MainActor.run {
                    isImageValid = scanResult.isImageValid
                    alertMessage = scanResult.errorCode.message
                    
                    if scanResult.isImageValid, let scanRows = scanResult.rows {
                        // We need at least headers and 1 row
                        if scanRows.count < 2 {
                            isImageValid = false
                            alertMessage = ErrorCode.LOG_DATA_NOT_FOUND.message
                            showAlert = true
                            return
                        }
                        
                        editableLog = EditableLog(
                            editableRows: scanRows.map { dto in
                                EditableRow(
                                    rowIndex: dto.rowIndex,
                                    header: dto.header,
                                    content: dto.content,
                                    parentHeaders: dto.parentHeaders
                                )
                            },
                            imageData: uiImage.jpegData(compressionQuality: 0.9)
                        )
                        
                    } else {
                        showAlert = true
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
