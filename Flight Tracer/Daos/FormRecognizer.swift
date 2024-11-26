import SwiftUI
import FirebasePerformance

struct FormRecognizer {
    
    //When server is up
    let realEndpoint = "https://flightlogtracer.com"

    //local
    let localEndpoint = "http://localhost"

    //test device (e.g. iphone) needs to use IP
    //let endpoint = "(insert IP here)"
    
    //TODO: Hardcode to Jeppesen. Eventually needs to allow dynamic selection of log format.
    let logFieldMetadata = LogMetadataLoader.getLogMetadata(named: "JeppesenLogFormat")
    
    func scanImage(imageDetail: ImageDetail, userToken: String, selectedScanType: Int) {
        let imageData = imageDetail.uiImage!.jpegData(compressionQuality: 0.9)!
        
        // Call localhost or real server
        if (selectedScanType == 0 || selectedScanType == 1) {
            print("Scan type selected: \(selectedScanType)")
            
            let urlString = selectedScanType == 0 ?"\(localEndpoint)/api/analyze/dummy" : "\(realEndpoint)/api/analyze"
            print("Using urlString: \(urlString)")

            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                return
            }
            
            let bearerToken = "Bearer \(userToken)"
            
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
                    setTransientError(imageDetail: imageDetail)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid response")
                    trace?.incrementMetric("InvalidResponse", by: 1)
                    trace?.stop()
                    setTransientError(imageDetail: imageDetail)
                    return
                }
                
                if (200...299).contains(httpResponse.statusCode) {
                    if let data = data {
                        // NOTE: Uncomment this to simulate latency when testing loading
                        // sleep (5)
                        trace?.incrementMetric("Success", by: 1)
                        trace?.stop()
                        let analyzeResult = try! JSONDecoder().decode(AnalyzeResult.self, from: data)
                        
                        print("Analyze Result: ")
                        print(analyzeResult)
                        
                        imageDetail.recognizedText = convertToArray(analyzeResult: analyzeResult, logFieldMetadata: logFieldMetadata)
                        processRecognizedTextForIntegers(imageDetail: imageDetail, logFieldMetadata: logFieldMetadata)
                        
                        imageDetail.analyzeResult = analyzeResult
                    }
                } else {
                    print("API request failed. Status code: \(httpResponse.statusCode)")
                    trace?.incrementMetric("UnhealthyResponse", by: 1)
                    trace?.stop()
                    setTransientError(imageDetail: imageDetail)
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
                        imageDetail.recognizedText = convertToArray(analyzeResult: analyzeResult, logFieldMetadata: logFieldMetadata)
                        processRecognizedTextForIntegers(imageDetail: imageDetail, logFieldMetadata: logFieldMetadata)
                        imageDetail.analyzeResult = analyzeResult
                    } else {
                        setTransientError(imageDetail: imageDetail)
                        print("Error converting string to data")
                    }
                } catch {
                    setTransientError(imageDetail: imageDetail)
                    print("Error reading file:", error.localizedDescription)
                }
            } else {
                setTransientError(imageDetail: imageDetail)
                
                print("File not found. Make sure the file is included in the app bundle and the filename and extension are correct.")
            }
        }
    }
    
    private func setTransientError(imageDetail: ImageDetail) {
        imageDetail.validationError = ErrorCode.TRANSIENT_FAILURE
        imageDetail.isImageValid = false
        imageDetail.analyzeResult = nil
    }
}

func processRecognizedTextForIntegers(imageDetail: ImageDetail, logFieldMetadata: [LogFieldMetadata]) {
    
    // Skip the first two rows because of headers
    for rowIndex in 3..<imageDetail.recognizedText.count {
        for columnIndex in 0..<imageDetail.recognizedText[rowIndex].count {
            if columnIndex < logFieldMetadata.count, logFieldMetadata[columnIndex].type == .INTEGER {
                
                // Sometimes the model gets numbers wrong and detects alphabetical characters instead of numbers
                imageDetail.recognizedText[rowIndex][columnIndex] = replaceCharacters(in: imageDetail.recognizedText[rowIndex][columnIndex])
            }
        }
    }
}

