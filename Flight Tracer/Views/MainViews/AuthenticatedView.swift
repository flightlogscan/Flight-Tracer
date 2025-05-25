import SwiftUI
import FirebaseAuthUI
import PhotosUI

struct AuthenticatedView: View {
    @EnvironmentObject var storeKitManager: StoreKitManager

    @State var selectedScanType: ScanType = .api
    @State var showStore = false
    @State var showScanSheet: Bool = false

    var body: some View {
        ZStack {
            if (showStore) {
                Color.semiTransparentBlack
                    .ignoresSafeArea(.all)
                    .zIndex(2)
            }
            
            NavigationStack {
                ZStack {
                    Rectangle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [.navyBlue, .black, .black]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                        .ignoresSafeArea(.all)
                        .accessibilityIdentifier("ScanBackground")
                    
                    LogListPlaceholderView()
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
                        HStack(spacing: 0) {
                            if storeKitManager.subscriptionStatusIsKnownAndNotSubscribed {
                                PremiumButton(showStore: $showStore)
                            }
                            
                            AddScanButtonView(showScanSheet: $showScanSheet)
                                .fullScreenCover(isPresented: $showScanSheet) {
                                    ScanView(selectedScanType: $selectedScanType, showStore: $showStore)
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
