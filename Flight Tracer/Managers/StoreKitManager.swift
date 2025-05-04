import StoreKit
import SwiftUI

@MainActor
class StoreKitManager: ObservableObject {
    @Published private(set) var purchasedProductIDs: Set<String> = []
    @Published var finishedCheckingSubscriptionStatus = false
    @Published var isRestoringPurchases = false
    @Published var restoreResultMessage: String?

    private let productIDs = [
        "com.flightlogscan.subscription.monthly",
        "com.flightlogscan.subscription.yearly"
    ]
        
    nonisolated init() {
        Task {
            await listenForTransactions()
        }
    }
    
    func isSubscribed() -> Bool {
        return !purchasedProductIDs.isDisjoint(with: productIDs)
    }
    
    var subscriptionStatusIsKnownAndNotSubscribed: Bool {
        finishedCheckingSubscriptionStatus && !isSubscribed()
    }
    
    func listenForTransactions() async {
        // Check current entitlements
        for await verification in StoreKit.Transaction.currentEntitlements {
            guard case .verified(let transaction) = verification,
                  productIDs.contains(transaction.productID) else {
                continue
            }
            await handle(transaction)
        }
        
        finishedCheckingSubscriptionStatus = true

        for await verification in StoreKit.Transaction.updates {
            guard case .verified(let transaction) = verification,
                  productIDs.contains(transaction.productID) else {
                continue
            }
            await handle(transaction)
        }
    }

    func restorePurchases() async {
        isRestoringPurchases = true
        defer { isRestoringPurchases = false }
        
        var didRestore = false
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                await handle(transaction)
                didRestore = true
            }
        }
        
        restoreResultMessage = didRestore
            ? "Purchases successfully restored."
            : "No previous purchases found."
    }


    
    private func handle(_ transaction: StoreKit.Transaction) async {
        await update(from: transaction)
        await transaction.finish()
    }
    
    private func update(from transaction: StoreKit.Transaction) async {
        if transaction.revocationDate == nil {
            purchasedProductIDs.insert(transaction.productID)
        } else {
            purchasedProductIDs.remove(transaction.productID)
        }
    }
    
    func manageSubscription() async {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            try? await AppStore.showManageSubscriptions(in: windowScene)
        }
    }
}
