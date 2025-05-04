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
                }
            }
        }
    }
}

extension String: @retroactive Identifiable {
    public var id: String { self }
}

struct AccountSection: View {
    @EnvironmentObject var storeKitManager: StoreKitManager
    @Binding var showStore: Bool

    var body: some View {
        Section("Account") {
            if !storeKitManager.isSubscribed() {
                // User hasn't purchased anything
                SettingsSheetButton(
                    title: "Premium",
                    iconName: "crown.fill",
                    color: Color.gold,
                    action: { showStore = true },
                    accessibilityIdentifier: "SubscriptionButton"
                )
                .premiumSheet(isPresented: $showStore) {
                    FLSStoreView()
                }
                
                // Restore Purchases button
                Button(action: {
                    Task {
                        await storeKitManager.restorePurchases()
                    }
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise.circle")
                            .frame(width: 24, height: 24)
                        if storeKitManager.isRestoringPurchases {
                            ProgressView()
                                .frame(height: 20)
                        } else {
                            Text("Restore Purchases")
                                .foregroundColor(.primary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                            .font(.caption2)
                    }
                }
                .accessibilityIdentifier("RestorePurchasesButton")
            } else {
                SettingsSheetButton(
                    title: "Manage Subscription",
                    iconName: "crown.fill",
                    color: Color.gold,
                    action: {
                        Task {
                            await storeKitManager.manageSubscription()
                        }
                    },
                    accessibilityIdentifier: "ManageSubscriptionButton"
                )
            }
        }
        .alert(item: $storeKitManager.restoreResultMessage) { message in
            Alert(title: Text(message))
        }
    }
}

struct SupportSection: View {
    @ObservedObject var parentViewModel = SettingsViewModel()

    var body: some View {
        Section("Support") {
            SettingsSheetButton(
                title: "Help",
                iconName: "questionmark.circle",
                action: { parentViewModel.openWebsite("https://www.flightlogscan.com/faq") },
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
                action: { parentViewModel.openWebsite("https://www.flightlogscan.com/privacy") },
                accessibilityIdentifier: "PrivacyWebsite"
            )
            SettingsSheetButton(
                title: "Terms & Conditions",
                iconName: "scroll",
                action: { parentViewModel.openWebsite("https://www.flightlogscan.com/terms") },
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
                        .fontWeight(.semibold)
                    Spacer()
                }
            }
            .listRowBackground(Color.gray.opacity(0.2))
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
