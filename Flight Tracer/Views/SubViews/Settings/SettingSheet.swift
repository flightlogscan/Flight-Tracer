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
            
            VStack (spacing: 0) {
                ZStack {
                    Text("Settings")
                        .font(.title3)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    HStack {
                        Spacer()
                        Button("Done", action: {
                            withAnimation {
                                showSettingsSheet = false
                            }
                        })
                        .foregroundStyle(.primary)
                    }
                }
                .frame(height: 44)
                .padding([.horizontal])
                .padding(.top, 8)
                
                List {
                    AccountSection(showStore: $showStore)
                    SupportSection(parentViewModel: settingsViewModel)
                    SignOutSection(selectedScanType: $selectedScanType)
                    if authManager.isAdmin() {
                        AdminSettingsSection(selectedScanType: $selectedScanType)
                    }
                        
                    DeleteAccountSection()
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
        .accessibilityIdentifier(accessibilityIdentifier ?? "")
    }
}
