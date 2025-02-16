import SwiftUI

class LogSwiperViewModel: ObservableObject {
    @Published var isImageValid: Bool = false
    @Published var alertMessage = ErrorCode.NO_ERROR.message
    @Published var showAlert: Bool = false
    @Published var rows: [RowDTO] = []
    
    let advancedImageScanner = AdvancedImageScanner()
    
    func scanImageForLogText(uiImage: UIImage, userToken: String, selectedScanType: ScanType) {
        Task {
            await MainActor.run {
                rows = []
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
                    
                    if scanResult.isImageValid, let tables = scanResult.tables {
                        rows = tables
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
    
    func processRows() -> LogData {
        // Get header row
        let headerRow = rows.first(where: { $0.header })?.content ?? [:]
        
        // Get data rows
        let dataRows = rows.filter { !$0.header }.map { row in
            MergedLogRow(fieldValues: row.content)
        }
        
        return LogData(headers: headerRow, rows: dataRows)
    }
}
