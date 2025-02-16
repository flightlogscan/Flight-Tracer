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
        
        // Find all data keys that need header duplication
        let allDataKeys = Set(rows.filter { !$0.header }.flatMap { $0.content.keys })
        
        // Create expanded headers by duplicating headers for keys without direct mapping
        var expandedHeaders: [String: String] = [:]
        for key in allDataKeys.sorted(by: { (Int($0) ?? 0) < (Int($1) ?? 0) }) {
            if headerRow[key] != nil {
                // If key has a direct header mapping, use it
                expandedHeaders[key] = headerRow[key]
            } else {
                // Find the previous header and duplicate it
                let keyNum = Int(key) ?? 0
                let previousHeaderKey = headerRow.keys
                    .compactMap { Int($0) }
                    .filter { $0 < keyNum }
                    .max()
                    .map { String($0) }
                
                if let prevKey = previousHeaderKey {
                    expandedHeaders[key] = headerRow[prevKey]
                }
            }
        }
        
        // Process data rows
        let dataRows = Dictionary(grouping: rows.filter { !$0.header }) { $0.rowIndex }
        let mergedRows = dataRows.map { (_, rowGroup) -> MergedLogRow in
            var mergedContent: [String: String] = [:]
            rowGroup.forEach { row in
                mergedContent.merge(row.content) { current, _ in current }
            }
            return MergedLogRow(fieldValues: mergedContent)
        }
        
        return LogData(headers: expandedHeaders, rows: mergedRows)
    }
}
