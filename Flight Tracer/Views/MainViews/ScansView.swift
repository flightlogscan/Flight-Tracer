import SwiftUI
import FirebaseAuthUI
import PhotosUI

struct ScansView: View {
    @Environment(\.modelContext) private var modelContext

    @EnvironmentObject var storeKitManager: StoreKitManager
    @EnvironmentObject var authManager: AuthManager

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
                    
                    LogListView(userId: authManager.user.id, modelContext: modelContext, showScanSheet: $showScanSheet)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("Scans")
                            .fixedSize()
                            .font(.custom("Magnolia Script", fixedSize: 36))
                            .accessibilityIdentifier("ToolbarTitle")
                    }
                    .sharedBackgroundVisibility(.hidden)
                                        
                    if storeKitManager.subscriptionStatusIsKnownAndNotSubscribed {
                        ToolbarItemGroup(placement: .topBarTrailing) {
                            PremiumButton(showStore: $showStore)
                                .accessibilityIdentifier("PremiumToolbarButton")
                        }
                        .sharedBackgroundVisibility(.hidden)
                        
                    }
                    
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        AddScanButtonView(showScanSheet: $showScanSheet)
                    }
                    
                    ToolbarSpacer(.flexible, placement: .topBarTrailing)
                    
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        SettingsButtonView(selectedScanType: $selectedScanType)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showScanSheet) {
            ScanView(selectedScanType: $selectedScanType, showStore: $showStore, showScanSheet: $showScanSheet)
        }
    }
}

#Preview {
    ScansView()
        .environmentObject(AuthManager())
        .environmentObject(StoreKitManager())
}
