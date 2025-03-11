import SwiftUI

class SettingsViewModel: ObservableObject {
    let CONTACT_EMAIL = "support@flightlogtracer.com"
    
    func openWebsite(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    func sendEmail() {
        if let url = URL(string: "mailto:\(CONTACT_EMAIL)") {
            UIApplication.shared.open(url) { success in
                if !success {
                    print("Unable to send email. Please configure your mail app.")
                }
            }
        } else {
            print("Unable to send email. Please configure your mail app.")
        }
    }
}
