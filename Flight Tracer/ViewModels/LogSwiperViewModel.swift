import SwiftUI

class LogSwiperViewModel: ObservableObject {
    @Published var isImageValid: Bool = false
    @Published var alertMessage = ErrorCode.NO_ERROR.message
    @Published var showAlert: Bool = false
    @Published var rows: [RowDTO] = []
    @Published var editableLogData: EditableLogData?
    @Published var exportURL: URL? // Store the export URL as a @Published property
    
    let advancedImageScanner = AdvancedImageScanner()
    
    func scanImageForLogText(uiImage: UIImage, userToken: String, selectedScanType: ScanType) {
        Task {
            await MainActor.run {
                rows = []
                isImageValid = false
                alertMessage = ErrorCode.NO_ERROR.message
                showAlert = false
                editableLogData = nil
                exportURL = nil
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
                        // Generate initial export URL
                        regenerateExportURL()
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
        print("LogSwiperViewModel.updateField called")
        print("Row: \(rowIndex), Field: \(fieldKey), New Value: \(newValue)")
        
        editableLogData?.updateValue(rowIndex: rowIndex, key: fieldKey, newValue: newValue)
        // Regenerate the export URL whenever an edit occurs
        regenerateExportURL()
    }
    
    func updateFieldName(oldKey: String, newName: String) {
        print("LogSwiperViewModel.updateFieldName called")
        print("Old Key: \(oldKey), New Name: \(newName)")
        
        editableLogData?.updateFieldName(oldKey: oldKey, newName: newName)
        // Regenerate the export URL whenever an edit occurs
        regenerateExportURL()
    }
    
    func regenerateExportURL() {
        print("Regenerating export URL")
        exportURL = convertLogRowsToCSV()
    }
    
    func convertLogRowsToCSV() -> URL {
        print("LogSwiperViewModel.convertLogRowsToCSV called")
        
        // Apply edits before generating CSV
        if let editableData = editableLogData {
            print("Using editableData to generate CSV")
            print("Content edits count: \(editableData.edits.contentEdits.count)")
            print("Header edits count: \(editableData.edits.headerEdits.count)")
            
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
            // Fall back to original logic if no editable data
            print("No editable data available, using original rows")
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
