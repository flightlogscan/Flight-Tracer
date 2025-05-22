import Foundation

enum DeleteAccountResult {
    case success
    case unauthorized
    case failure(Error)
}

struct FLTDeleteAccount {
    
    func deleteAccount(withToken token: String, selectedScanType: ScanType) async -> DeleteAccountResult {
        let localEndpoint = "http://localhost:8080"
        let realEndpoint = "https://api.flightlogscan.com"
        let endpoint = selectedScanType == .localhost ? localEndpoint : realEndpoint
        print("Attempting to delete account using endpoint: \(endpoint)")
        guard let url = URL(string: "\(endpoint)/api/account/delete") else {
            return .failure(NSError(domain: "Invalid URL", code: 0))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            print("Received response from delete account request")
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(NSError(domain: "No HTTP response", code: 0))
            }
            
            switch httpResponse.statusCode {
            case 200:
                print("Delete account succeeded with status code 200")
                return .success
            case 401:
                print("Delete account unauthorized with status code 401")
                return .unauthorized
            default:
                print("Delete account failed with status code \(httpResponse.statusCode)")
                return .failure(NSError(domain: "DeleteAccount", code: httpResponse.statusCode))
            }
        } catch {
            print("Delete account request failed with error: \(error)")
            return .failure(error)
        }
    }
}
