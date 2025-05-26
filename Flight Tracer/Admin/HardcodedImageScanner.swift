import SwiftUI

// Use hardcoded data instead of calling a server
func hardCodedImageScan() -> AdvancedImageScanResult {
    print("Scan type 2, using hardcoded data")
    
    // Try to load the sample response JSON file
    if let filePath = Bundle.main.path(forResource: "SampleResultResponse", ofType: "json") {
        do {
            let fileContent = try String(contentsOfFile: filePath)
            print("File content:")
            print(fileContent)
            
            // Convert string to data
            if let fileData = fileContent.data(using: .utf8) {
                // Parse the response using the existing AnalyzeImageResponse struct
                let analyzeImageResponse = try JSONDecoder().decode(AnalyzeImageResponse.self, from: fileData)
                
                // Extract the analyzeResult if it exists in the JSON
                var analyzeResult = AnalyzeResult(content: "", tables: [])
                if let rawResults = analyzeImageResponse.rawResults,
                   let rawResultsData = rawResults.data(using: .utf8) {
                    analyzeResult = try JSONDecoder().decode(AnalyzeResult.self, from: rawResultsData)
                }
                
                return AdvancedImageScanResult(
                    isImageValid: true,
                    errorCode: ErrorCode.NO_ERROR,
                    analyzeResult: analyzeResult,
                    rows: analyzeImageResponse.tables ?? []
                )
            } else {
                print("Error with sample response deserialization")
                return AdvancedImageScanResult(isImageValid: false, errorCode: ErrorCode.HARDCODED_ERROR, rows: [])
            }
        } catch {
            print("Error with sample response content: \(error)")
            return AdvancedImageScanResult(isImageValid: false, errorCode: ErrorCode.HARDCODED_ERROR, rows: [])
        }
    } else {
        print("Error with sample response file")
        return AdvancedImageScanResult(isImageValid: false, errorCode: ErrorCode.HARDCODED_ERROR, rows: [])
    }
}
