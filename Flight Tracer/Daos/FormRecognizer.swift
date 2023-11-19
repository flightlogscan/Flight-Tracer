import SwiftUI

let endpoint = "https://flightlogrecorder.cognitiveservices.azure.com"
let apiKey = "" // TODO: For now let's add our keys locally here - Not sure if it's good practice to commit these directly?

struct FormRecognizer {
    
    func scanImage(image: ImageDetail) {
        
        let imageData = image.uiImage.jpegData(compressionQuality: 0.9)!
        
        submitImageAndGetResults(imageData: imageData)
    }
    
    func submitImageAndGetResults(imageData: Data) {
        let urlString = "\(endpoint)/formrecognizer/documentModels/prebuilt-layout:analyze?api-version=2022-08-31"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(apiKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        request.httpBody = imageData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                if data != nil {
                    // After posting the image this result ID is used to retrieve the analysis result
                    let resultId: String = httpResponse.allHeaderFields["operation-location"] as! String
                    
                    getResults(resultId: resultId) { (resultStatus) in
                        // This should only be executed once the result status is in a terminal state (successful or failed)
                        // TODO: Consume the actual result instead of just the status, then set it into the image for later post-processing
                        print("Terminal result status: " + resultStatus)
                        
                    }
                }
            } else {
                print("API request failed. Status code: \(httpResponse.statusCode)")
            }
        }
        
        task.resume()
    }
    
    func getResults(resultId: String, completionHandler: @escaping (String) -> Void) {
        guard let resultUrl = URL(string: resultId) else {
            print("Invalid URL")
            return
        }
        
        var resultRequest = URLRequest(url: resultUrl)
        resultRequest.httpMethod = "GET"
        resultRequest.setValue(apiKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        
        // TODO: Add polling every X seconds until the result is ready - currently it only checks once immediately and is always still in a "running" state
        let resultTask = URLSession.shared.dataTask(with: resultRequest) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                if let data = data {
                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    
                    let jsonDict = json as? [String: Any]
                    
                    print("Result status: ")
                    
                    let resultStatus = jsonDict!["status"] as? String
                    
                    if let resultStatus = resultStatus {
                        
                        if (resultStatus == "" || resultStatus == "running" || resultStatus == "notStarted") {
                            // Result isn't ready yet, wait 5 seconds between each attempt to retrieve results
                            sleep(5) // TODO: Remove hardcoding
                            getResults(resultId: resultId, completionHandler: completionHandler)
                        } else {
                            // Leaving these useful logs in here (commented out) for now while we're actively working in here
                            // print("Full json response: ")
                            // print(json!)
                            // print("Json dict: ")
                            // print(jsonDict!)
                            
                            // TODO: Pass along the actual anlysis result instead of just the status
                            // TODO: Validate the result status was "succeeded", handle failure if not
                            completionHandler(resultStatus)
                        }
                    }
                }
            } else {
                print("API request failed. Status code: \(httpResponse.statusCode)")
            }
        }
        
        resultTask.resume()
    }
}
