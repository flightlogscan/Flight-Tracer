import SwiftUI

struct DiscardScanButtonView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Menu {
            Button(role: .destructive) {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Label {
                    Text("Close and Delete Scan")
                } icon: {
                    Image(systemName: "trash")
                }
                .labelStyle(.titleAndIcon)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        } label: {
            Image(systemName: "xmark.circle.fill")
                .font(.title)
                .foregroundStyle(Color.primary, .ultraThinMaterial)
        }
        .accessibilityIdentifier("DeleteLog")
    }
}
