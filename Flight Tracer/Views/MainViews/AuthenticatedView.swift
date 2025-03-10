import SwiftUI
import FirebaseAuthUI
import PhotosUI

struct AuthenticatedView: View {
    @EnvironmentObject var storeKitManager: StoreKitManager

    @State var selectedScanType: ScanType = .api
    @State private var showStore = false

    var body: some View {
        ZStack {
            if (showStore) {
                Color.semiTransparentBlack
                    .ignoresSafeArea(.all)
                    .zIndex(2)
            }
            
            NavigationStack {
                ZStack {
                    SubscriptionCoordinator(selectedScanTye: $selectedScanType)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("Scan")
                            .font(.custom(
                                "Magnolia Script",
                                fixedSize: 36))
                            .foregroundStyle(.white)
                            .accessibilityIdentifier("ToolbarTitle")
                    }
                    
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        HStack(spacing: 4) {
                            if (!storeKitManager.isSubscribed()) {
                                PremiumButton(showStore: $showStore)
                            }
                            
                            SettingsButtonView(selectedScanType: $selectedScanType)
                        }
                    }
                }
                .toolbarBackground(.hidden, for: .navigationBar)
            }
        }
    }
}

#Preview {
    AuthenticatedView()
}
