struct AdvancedImageScanResult {
    let isImageValid: Bool
    let errorCode: ErrorCode
    var analyzeResult: AnalyzeResult? = nil
    let rows: [RowDTO]?
}
