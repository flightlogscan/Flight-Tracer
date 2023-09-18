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
        
        print("Before request")
        
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
                if let data = data {
                    // After posting the image this result ID is used to retrieve the analysis result
                    let resultId: String = httpResponse.allHeaderFields["operation-location"] as! String
                    print(resultId)
                    
                    getResults(resultId: resultId)
                }
            } else {
                print("API request failed. Status code: \(httpResponse.statusCode)")
            }
        }
        
        task.resume()
    }
    
    func getResults(resultId: String) {
        guard let resultUrl = URL(string: resultId) else {
            print("Invalid URL")
            return
        }
        
        var resultRequest = URLRequest(url: resultUrl)
        resultRequest.httpMethod = "GET"
        resultRequest.setValue(apiKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        
        print("Result API returned")
        
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
                    
                    print("Result status:")
                    print (jsonDict!["status"]!)
                    
                    // TODO: Set result into image once it's ready
                }
            } else {
                print("API request failed. Status code: \(httpResponse.statusCode)")
            }
        }
        
        resultTask.resume()
    }
}
