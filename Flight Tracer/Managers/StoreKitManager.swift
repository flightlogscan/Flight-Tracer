import StoreKit
import SwiftUI

@MainActor
final class StoreKitManager: ObservableObject {
    @Published private(set) var purchasedProductIDs: Set<String> = []
    @Published var finishedCheckingSubscriptionStatus = false

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
    
    private func listenForTransactions() async {
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
}
