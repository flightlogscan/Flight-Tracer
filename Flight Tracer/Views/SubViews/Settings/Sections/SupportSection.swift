import SwiftUI

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

