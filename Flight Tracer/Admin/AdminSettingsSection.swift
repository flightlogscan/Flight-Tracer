import SwiftUI

struct AdminSettingsSection: View {
    @Binding var selectedScanType: ScanType
    
    var body: some View {
        Section("Admin") {
            Menu {
                ForEach(ScanType.allCases) { option in
                    Button(action: {
                        selectedScanType = option
                    }) {
                        Text(option.displayName)
                    }
                }
            } label: {
                HStack {
                    Text("API Options")
                        .foregroundColor(.primary)
                    Spacer()
                    Text(selectedScanType.displayName)
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                        .font(.caption2)
                }
                .contentShape(Rectangle())
            }
            .accessibilityIdentifier("ScanTypeMenu")
        }
    }
}
