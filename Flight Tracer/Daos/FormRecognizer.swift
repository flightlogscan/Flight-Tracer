import SwiftUI

//When server is up
//let endpoint = "https://flightlogtracer.com"

//local
let endpoint = "http://localhost"

//test device (e.g. iphone) needs to use IP
//let endpoint = "(insert IP here)"

struct FormRecognizer {
    
    func scanImage(image: ImageDetail, user: User?) {
        submitImageAndGetResults(imageDetail: image, user: user)
    }
    
    func submitImageAndGetResults(imageDetail: ImageDetail, user: User?) {
        let imageData = imageDetail.uiImage.jpegData(compressionQuality: 0.9)!
        // no call to azure
        let urlString = "\(endpoint)/api/analyze/dummy"
        
        // real call to azure
        //let urlString = "\(endpoint)/api/analyze"

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
                    // NOTE: Uncomment this to simulate latency when testing loading
                    sleep (2)
                    let analyzeResult = try! JSONDecoder().decode(AnalyzeResult.self, from: data)
                    
                    print("Analyze Result: ")
                    print(analyzeResult)
                    imageDetail.analyzeResult = analyzeResult
                }
            } else {
                print("API request failed. Status code: \(httpResponse.statusCode)")
            }
        }
        
        task.resume()
    }
}
