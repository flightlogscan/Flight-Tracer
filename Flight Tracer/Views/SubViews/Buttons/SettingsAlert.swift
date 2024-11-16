import SwiftUI

struct SettingsAlert: View {
    var body: some View {
        Button ("Open Settings") {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
        Button ("Cancel") {
        }
    }
}
