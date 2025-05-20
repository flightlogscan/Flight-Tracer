import SwiftUI

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

