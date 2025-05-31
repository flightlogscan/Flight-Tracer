import SwiftUI

class SettingsViewModel: ObservableObject {
    let CONTACT_EMAIL = "support@flightlogscan.com"
    
    func openWebsite(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    func sendEmail() {
        if let url = URL(string: "mailto:\(CONTACT_EMAIL)") {
            UIApplication.shared.open(url) { success in
                if !success {
                    // TODO: Potentially needs real UI error handling to let user know of email error?
                    print("Unable to send email. Please configure your mail app.")
                }
            }
        } else {
            // TODO: Potentially needs real UI error handling to let user know of email error?
            print("Unable to send email. Please configure your mail app.")
        }
    }
}
