import SwiftUI

struct SettingsSheet: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    @Binding var isSheetPresented: Bool
    @Binding var selectedScanType: ScanType
    
    @ObservedObject var viewModel = SettingsViewModel()

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
                            .imageScale(.medium) // Makes the SF Symbol larger
                            .font(.system(size: 28)) // Adjust size as needed
                    }
                }
            }
            .frame(height: 44)
            .padding([.horizontal])
            .padding(.top, 8)
            .background(Color(.systemGroupedBackground))

            List {
                SupportSection(parentViewModel: viewModel)
                AccountSection(selectedScanType: $selectedScanType)
                if authViewModel.isAdmin() {
                    AdminSettingsSection(selectedScanType: $selectedScanType)
                }
            }
        }
    }
}

struct SupportSection: View {
    @ObservedObject var parentViewModel = SettingsViewModel()

    var body: some View {
        Section("Support") {
            SettingsButton(
                title: "FAQ",
                iconName: "questionmark.circle",
                action: { parentViewModel.openWebsite("https://www.flightlogtracer.com/faq") },
                accessibilityIdentifier: "FAQWebsite"
            )
            SettingsButton(
                title: "Contact",
                iconName: "envelope",
                action: { parentViewModel.sendEmail() },
                accessibilityIdentifier: "ContactButton"
            )
            SettingsButton(
                title: "Privacy",
                iconName: "lock.shield",
                action: { parentViewModel.openWebsite("https://www.flightlogtracer.com/privacy") },
                accessibilityIdentifier: "PrivacyWebsite"
            )
            SettingsButton(
                title: "Terms of Use",
                iconName: "scroll",
                action: { parentViewModel.openWebsite("https://www.flightlogtracer.com/terms") },
                accessibilityIdentifier: "TermsWebsite"
            )
        }
    }
}

struct AccountSection: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var selectedScanType: ScanType

    var body: some View {
        Section {
            Button(action: authViewModel.signOut) {
                HStack {
                    Spacer()
                    Text("Sign Out")
                        .tint(.red)
                    Spacer()
                }
            }
            .accessibilityIdentifier("SignOutButton")
        }
    }
}

struct SettingsButton: View {
    let title: String
    let iconName: String
    let action: () -> Void
    var accessibilityIdentifier: String?

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.navyBlue)
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
