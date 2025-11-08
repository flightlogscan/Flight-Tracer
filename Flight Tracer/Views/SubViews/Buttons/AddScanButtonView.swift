import SwiftUI

struct AddScanButtonView: View {
    @Binding var showScanSheet: Bool
    
    var body: some View {
        Button("Add Scan", systemImage: "plus") {
            showScanSheet = true
        }
    }
}

#Preview {
    ScansView()
        .environmentObject(AuthManager())
        .environmentObject(StoreKitManager())
}
