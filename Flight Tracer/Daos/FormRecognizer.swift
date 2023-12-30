import SwiftUI

let endpoint = "https://flightlogtracer.com"

struct FormRecognizer {
    
    func scanImage(image: ImageDetail) {
        
        let imageData = image.uiImage.jpegData(compressionQuality: 0.9)!
        
        submitImageAndGetResults(imageData: imageData)
    }
    
    func submitImageAndGetResults(imageData: Data) {
        let urlString = "\(endpoint)/api/analyze"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
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
                print("Response: ")
                print(httpResponse)
            } else {
                print("API request failed. Status code: \(httpResponse.statusCode)")
            }
        }
        
        task.resume()
    }
}
