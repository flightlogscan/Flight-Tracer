import SwiftUI

struct AddScanButtonView: View {
    @Binding var showScanSheet: Bool
    
    var body: some View {
        Button {
            showScanSheet = true
        } label: {
            Image(systemName: "plus.circle.fill")
                .font(.title)
                .foregroundStyle(.regularMaterial)
        }
        .environment(\.colorScheme, .light)
    }
}
