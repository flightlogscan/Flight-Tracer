import SwiftUI
import StoreKit

struct SettingsSheet: View {
    @EnvironmentObject var authManager: AuthManager

    @Binding var isSheetPresented: Bool
    @Binding var selectedScanType: ScanType
    
    @ObservedObject var settingsViewModel = SettingsViewModel()

    var body: some View {
        VStack (spacing: 0) {

            ZStack {
                Text("Settings")
                    .font(.system(size: 20, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .center) // Center the text within the ZStack
                
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            isSheetPresented = false
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray, .gray.opacity(0.2))
                            .imageScale(.medium)
                            .font(.system(size: 28))
                    }
                }
            }
            .frame(height: 44)
            .padding([.horizontal])
            .padding(.top, 8)
            .background(Color(.systemGroupedBackground))

            List {
                AccountSection()
                SupportSection(parentViewModel: settingsViewModel)
                SignOutSection(selectedScanType: $selectedScanType)
                if authManager.isAdmin() {
                    AdminSettingsSection(selectedScanType: $selectedScanType)
                }
            }
        }
    }
}

struct AccountSection: View {
    @State private var showSubscription = false
    
    var body: some View {
        SettingsSheetButton(
            title: "Premium",
            iconName: "crown.fill",
            color: Color.gold,
            action: { showSubscription = true },
            accessibilityIdentifier: "SubscriptionButton"
        )
        .sheet(isPresented: $showSubscription) {
            CustomSubscriptionStoreView()
        }
    }
}

struct SupportSection: View {
    @ObservedObject var parentViewModel = SettingsViewModel()

    var body: some View {
        Section("Support") {
            SettingsSheetButton(
                title: "FAQ",
                iconName: "questionmark.circle",
                action: { parentViewModel.openWebsite("https://www.flightlogtracer.com/faq") },
                accessibilityIdentifier: "FAQWebsite"
            )
            SettingsSheetButton(
                title: "Contact",
                iconName: "envelope",
                action: { parentViewModel.sendEmail() },
                accessibilityIdentifier: "ContactButton"
            )
            SettingsSheetButton(
                title: "Privacy",
                iconName: "lock.shield",
                action: { parentViewModel.openWebsite("https://www.flightlogtracer.com/privacy") },
                accessibilityIdentifier: "PrivacyWebsite"
            )
            SettingsSheetButton(
                title: "Terms of Use",
                iconName: "scroll",
                action: { parentViewModel.openWebsite("https://www.flightlogtracer.com/terms") },
                accessibilityIdentifier: "TermsWebsite"
            )
        }
    }
}

struct SignOutSection: View {
    @EnvironmentObject var authManager: AuthManager
    
    @State var showAlert = false
    
    @Binding var selectedScanType: ScanType

    var body: some View {
        Section {
            Button(action: { showAlert = true }) {
                HStack {
                    Spacer()
                    Text("Sign Out")
                        .foregroundColor(.red)
                    Spacer()
                }
            }
            .alert("Sign Out?", isPresented: $showAlert) {
                Button("Cancel", role: .cancel) { }
                
                Button("Sign Out", role: .destructive) {
                    authManager.signOut()
                }
            } message: {
                Text("Any files not yet saved will be lost if you sign out. Are you sure you want to sign out?")
            }
            .accessibilityIdentifier("SignOutButton")
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
                    .foregroundColor(color ?? .navyBlue)
                    .frame(width: 24, height: 24)
                Text(title)
                    .tint(.black)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .accessibilityIdentifier(accessibilityIdentifier ?? "")
    }
}
