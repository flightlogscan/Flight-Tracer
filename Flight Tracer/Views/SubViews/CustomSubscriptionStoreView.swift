import SwiftUI
import StoreKit

struct CustomSubscriptionStoreView: View {
    var body: some View {
        SubscriptionStoreView(groupID: "21625926")
           .subscriptionStoreButtonLabel(.multiline)
           .subscriptionStorePickerItemBackground(.thinMaterial)
           .storeButton(.visible, for: .restorePurchases)
           .tint(Color.navyBlue)
    }
}

#Preview {
    CustomSubscriptionStoreView()
}
