import SwiftUI

struct AddScanButtonView: View {
    @Binding var showScanSheet: Bool
    
    var body: some View {
        Button {
            showScanSheet = true
        } label: {
            Image(systemName: "plus")
                .font(.title3)
                .symbolRenderingMode(.monochrome)
                .foregroundColor(.white)
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .environment(\.colorScheme, .light)
    }
}
