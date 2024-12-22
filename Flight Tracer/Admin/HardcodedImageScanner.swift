import SwiftUI

// Use hardcoded data instead of calling a server
func hardCodedImageScan() -> AdvancedImageScanResult {
    print("Scan type 2, using hardcoded data")
    
    if let filePath = Bundle.main.path(forResource: "SampleResultResponse", ofType: "json") {
        do {
            let fileContent = try String(contentsOfFile: filePath)
            print("File content:")
            print(fileContent)
            
            // Convert string to data
            if let fileData = fileContent.data(using: .utf8) {
                let analyzeResult = try JSONDecoder().decode(AnalyzeResult.self, from: fileData)
                return AdvancedImageScanResult(isImageValid: true, errorCode: ErrorCode.NO_ERROR, analyzeResult: analyzeResult)
            } else {
                print("Error with sample response deserialization")
                return AdvancedImageScanResult(isImageValid: false, errorCode: ErrorCode.HARDCODED_ERROR)
            }
        } catch {
            print("Error with sample response content")
            return AdvancedImageScanResult(isImageValid: false, errorCode: ErrorCode.HARDCODED_ERROR)
        }
    } else {
        print("Error with sample response file")
        return AdvancedImageScanResult(isImageValid: false, errorCode: ErrorCode.HARDCODED_ERROR)
    }
}
