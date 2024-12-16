import SwiftUI
import FirebasePerformance

struct AdvancedImageScanner {
    
    //When server is up
    let realEndpoint = "https://api.flightlogtracer.com"

    //local
    let localEndpoint = "http://localhost"

    //test device (e.g. iphone) needs to use IP
    //let endpoint = "(insert IP here)"
    
    //TODO: Remove all the prints in here once testing / validation complete
    func analyzeImageAsync(uiImage: UIImage, userToken: String, selectedScanType: ScanType) async throws -> AdvancedImageScanResult {
        
        if (selectedScanType == .localhost || selectedScanType == .api) {
            print("Scan type selected: \(selectedScanType)")
            
            let urlString = selectedScanType == .localhost ? "\(localEndpoint)/api/analyze/dummy" : "\(realEndpoint)/api/analyze"
            print("Using urlString: \(urlString)")

            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                return AdvancedImageScanResult(isImageValid: false, errorCode: ErrorCode.INVALID_REQUEST)
            }
            
            let bearerToken = "Bearer \(userToken)"
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
            request.setValue(bearerToken, forHTTPHeaderField: "Authorization")
            request.httpBody = uiImage.jpegData(compressionQuality: 0.9)!
            
            print("url: \(url)")
            print("headers: \(String(describing: request.allHTTPHeaderFields))")
            
            let trace = Performance.startTrace(name: "BackendImageRequest")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                trace?.incrementMetric("InvalidResponse", by: 1)
                trace?.stop()
                return AdvancedImageScanResult(isImageValid: false, errorCode: ErrorCode.SERVER_ERROR)
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                // NOTE: Uncomment this to simulate latency when testing loading
                // sleep (5)
                trace?.incrementMetric("Success", by: 1)
                trace?.stop()
                let analyzeResult = try! JSONDecoder().decode(AnalyzeResult.self, from: data)
                
                print("Analyze Result: ")
                print(analyzeResult)
                                        
                return AdvancedImageScanResult(isImageValid: true, errorCode: ErrorCode.NO_ERROR, analyzeResult: analyzeResult)
            } else {
                print("API request failed. Status code: \(httpResponse.statusCode)")
                trace?.incrementMetric("UnhealthyResponse", by: 1)
                trace?.stop()
                return AdvancedImageScanResult(isImageValid: false, errorCode: ErrorCode.SERVER_ERROR)
            }
        } else {
            return hardCodedImageScan()
        }
    }
}

