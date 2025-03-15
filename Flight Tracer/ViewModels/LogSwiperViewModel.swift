import SwiftUI

class LogSwiperViewModel: ObservableObject {
    @Published var isImageValid: Bool = false
    @Published var alertMessage = ErrorCode.NO_ERROR.message
    @Published var showAlert: Bool = false
    @Published var rows: [RowDTO] = []
    @Published var editableLogData: EditableLogData?
    @Published var editCounter: Int = 0 // To track when edits occur
    
    let advancedImageScanner = AdvancedImageScanner()
    
    func scanImageForLogText(uiImage: UIImage, userToken: String, selectedScanType: ScanType) {
        Task {
            await MainActor.run {
                rows = []
                isImageValid = false
                alertMessage = ErrorCode.NO_ERROR.message
                showAlert = false
                editableLogData = nil
                editCounter = 0
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
                        editableLogData = EditableLogData(rows: tables)
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
    
    func updateField(rowIndex: Int, fieldKey: String, newValue: String) {
        editableLogData?.updateValue(rowIndex: rowIndex, key: fieldKey, newValue: newValue)
        editCounter += 1 // Increment the edit counter
    }
    
    func updateFieldName(oldKey: String, newName: String) {
        editableLogData?.updateFieldName(oldKey: oldKey, newName: newName)
        editCounter += 1 // Increment the edit counter
    }
    
    func convertLogRowsToCSV() -> URL {
        // Apply edits before generating CSV
        if let editableData = editableLogData {
            let editedRows = editableData.getEditedRows()
            
            // Use edited rows for CSV generation
            let headerRow = editedRows.first(where: { $0.header })?.content ?? [:]
            let dataRows = editedRows.filter { !$0.header }.sorted(by: { $0.rowIndex < $1.rowIndex }).map { row in
                MergedLogRow(fieldValues: row.content)
            }
            
            let logData = LogData(headers: headerRow, rows: dataRows)
            
            if let fileURL = CSVCreator.createCSVFile(logData, filename: "flight_log.csv") {
                print("CSV created at: \(fileURL.path)")
                return fileURL
            }
        } else {
            let logData = processRows()
            if let fileURL = CSVCreator.createCSVFile(logData, filename: "flight_log.csv") {
                return fileURL
            }
        }
        
        // Return a default URL in case of failure
        print("Failed to create CSV, returning default URL")
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("flight_log.csv")
    }
    
    private func processRows() -> LogData {
        let headerRow = rows.first(where: { $0.header })?.content ?? [:]
        
        let dataRows = rows.filter { !$0.header }.map { row in
            MergedLogRow(fieldValues: row.content)
        }
        
        return LogData(headers: headerRow, rows: dataRows)
    }
}
