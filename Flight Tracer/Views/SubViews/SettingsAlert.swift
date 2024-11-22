import SwiftUI

struct SettingsAlert: View {
    var body: some View {
        Button ("Cancel", role: .cancel) {
        }
        Button ("Open Settings") {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
    }
}
