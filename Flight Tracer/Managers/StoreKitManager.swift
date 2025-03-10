import StoreKit
import SwiftUI

@MainActor
class StoreKitManager: ObservableObject {
    @Published private(set) var purchasedProductIDs: Set<String> = []
    @Published var finishedCheckingSubscriptionStatus = false

    private let productIDs = [
        "com.flightlogscan.premium",
        "com.flightlogscan.subscription.monthly.nonrenewing"
    ]
        
    nonisolated init() {
        Task {
            await listenForTransactions()
        }
    }
    
    func isSubscribed() -> Bool {
        return !purchasedProductIDs.isDisjoint(with: productIDs)
    }
    
    public func listenForTransactions() async {
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
    
    func manageSubscription() async {
       if #available(iOS 15.0, *) {
           if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
               try? await AppStore.showManageSubscriptions(in: windowScene)
           }
       } else {
           if let url = URL(string: "itms-apps://apps.apple.com/account/subscriptions") {
               await UIApplication.shared.open(url)
           }
       }
    }
}
