import SwiftUI
import StoreKit

struct SettingsSheet: View {
    @EnvironmentObject var authManager: AuthManager
    
    @State var showStore = false

    @Binding var showSettingsSheet: Bool
    @Binding var selectedScanType: ScanType
    
    @ObservedObject var settingsViewModel = SettingsViewModel()

    var body: some View {
        ZStack {
            if (showStore) {
                Color.semiTransparentBlack
                    .ignoresSafeArea(.all)
                    .zIndex(1)
            }
            
            NavigationStack {
                List {
                    AccountSection(showStore: $showStore)
                    SupportSection(parentViewModel: settingsViewModel)
                    
                    SignOutSection(selectedScanType: $selectedScanType)
                    if authManager.isAdmin() {
                        AdminSettingsSection(selectedScanType: $selectedScanType)
                    }
                        
                    DeleteAccountSection(selectedScanType: selectedScanType)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Settings")
                            .font(.title3)
                            .fontWeight(.medium)
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done", systemImage: "checkmark") {
                            withAnimation {
                                showSettingsSheet = false
                            }
                        }
                        .tint(.white)
                    }
                }
            }
        }
    }
}

struct SettingsSheetButton: View {
    let title: String
    let iconName: String
    var color: Color?
    let action: () -> Void
    var accessibilityIdentifier: String?

    var body: some View {
        Button(action: action) {
            SettingsButtonTextFormat(title: title, iconName: iconName, color: color)
        }
        .accessibilityIdentifier(accessibilityIdentifier ?? "")
    }
}

struct SettingsButtonTextFormat: View {
    let title: String
    let iconName: String
    var color: Color?

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(color ?? .primary)
                .frame(width: 24, height: 24)
            Text(title)
                .foregroundColor(.primary)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.caption2)
        }
    }
}

#Preview {
    ScansView()
        .environmentObject(AuthManager())
        .environmentObject(StoreKitManager())

}
