import SwiftUI
import FirebaseAuthUI
import PhotosUI

struct ScansView: View {
    @Environment(\.modelContext) private var modelContext

    @EnvironmentObject var storeKitManager: StoreKitManager
    @EnvironmentObject var authManager: AuthManager

    @State var selectedScanType: ScanType = .hardcoded
    @State var showStore = false
    @State var showScanSheet: Bool = false

    var body: some View {
        ZStack {
            if (showStore) {
                Color.semiTransparentBlack
                    .ignoresSafeArea(.all)
                    .zIndex(2)
            }
            
            NavigationStack() {
                ZStack {
                    Rectangle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [.navyBlue, .black, .black]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                        .ignoresSafeArea(.all)
                        .accessibilityIdentifier("ScanBackground")
                    
                    LogListView(userId: authManager.user.id, modelContext: modelContext, showScanSheet: $showScanSheet)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("Scans")
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
                                    ScanView(selectedScanType: $selectedScanType, showStore: $showStore, showScanSheet: $showScanSheet)
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
    ScansView()
}
