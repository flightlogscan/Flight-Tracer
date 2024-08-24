import SwiftUI
import FirebasePerformance


//When server is up
let realEndpoint = "https://flightlogtracer.com"

//local
let localEndpoint = "http://localhost"

//test device (e.g. iphone) needs to use IP
//let endpoint = "(insert IP here)"

struct FormRecognizer {
    
    func scanImage(image: ImageDetail, user: User?, selectedScanType: Int) {
        submitImageAndGetResults(imageDetail: image, user: user, selectedScanType: selectedScanType)
    }
    
    func submitImageAndGetResults(imageDetail: ImageDetail, user: User?, selectedScanType: Int) {
        let imageData = imageDetail.uiImage!.jpegData(compressionQuality: 0.9)!
        
        // Call localhost or real server
        if (selectedScanType == 0 || selectedScanType == 1) {
            print("Scan type selected: ")
            print(selectedScanType)
            
            let urlString = selectedScanType == 0 ?"\(localEndpoint)/api/analyze/dummy" : "\(realEndpoint)/api/analyze"
            print("Using urlString: ")
            print(urlString)

            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                return
            }
            
            let bearerToken = "Bearer \(user!.token!)"
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
            request.setValue(bearerToken, forHTTPHeaderField: "Authorization")
            request.httpBody = imageData
            
            print("url: \(url)")
            print("headers: \(String(describing: request.allHTTPHeaderFields))")
            
            let trace = Performance.startTrace(name: "BackendImageRequest")
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    trace?.incrementMetric("Error", by: 1)
                    trace?.stop()
                    print("Error: \(error.localizedDescription)")
                    imageDetail.validationResult = ErrorCode.TRANSIENT_FAILURE
                    imageDetail.isImageValid = false
                    imageDetail.analyzeResult = nil
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid response")
                    trace?.incrementMetric("InvalidResponse", by: 1)
                    trace?.stop()
                    imageDetail.validationResult = ErrorCode.TRANSIENT_FAILURE
                    imageDetail.isImageValid = false
                    imageDetail.analyzeResult = nil
                    return
                }
                
                if (300...399).contains(httpResponse.statusCode) {
                    if let data = data {
                        // NOTE: Uncomment this to simulate latency when testing loading
                        // sleep (5)
                        trace?.incrementMetric("Success", by: 1)
                        trace?.stop()
                        let analyzeResult = try! JSONDecoder().decode(AnalyzeResult.self, from: data)
                        
                        print("Analyze Result: ")
                        print(analyzeResult)
                        imageDetail.analyzeResult = analyzeResult
                    }
                } else {
                    print("API request failed. Status code: \(httpResponse.statusCode)")
                    trace?.incrementMetric("UnhealthyResponse", by: 1)
                    trace?.stop()
                    imageDetail.validationResult = ErrorCode.TRANSIENT_FAILURE
                    imageDetail.isImageValid = false
                    imageDetail.analyzeResult = nil
                }
            }
            
            task.resume()
        }
        
        // Use hardcoded data instead of calling a server
        else if (selectedScanType == 2) {
            print("Scan type 2, using hardcoded data")
            
            if let filePath = Bundle.main.path(forResource: "SampleResultResponse", ofType: "json") {
                do {
                    let fileContent = try String(contentsOfFile: filePath)
                    print("File content:")
                    print(fileContent)
                    
                    // Convert string to data
                    if let fileData = fileContent.data(using: .utf8) {
                        let analyzeResult = try JSONDecoder().decode(AnalyzeResult.self, from: fileData)
                        imageDetail.analyzeResult = analyzeResult
                    } else {
                        imageDetail.validationResult = ErrorCode.TRANSIENT_FAILURE
                        imageDetail.isImageValid = false
                        imageDetail.analyzeResult = nil
                        print("Error converting string to data")
                    }
                } catch {
                    imageDetail.validationResult = ErrorCode.TRANSIENT_FAILURE
                    imageDetail.isImageValid = false
                    imageDetail.analyzeResult = nil
                    print("Error reading file:", error.localizedDescription)
                }
            } else {
                imageDetail.validationResult = ErrorCode.TRANSIENT_FAILURE
                imageDetail.isImageValid = false
                imageDetail.analyzeResult = nil
                print("File not found. Make sure the file is included in the app bundle and the filename and extension are correct.")
            }
        }
    }
}
