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
                    ToolbarItem(placement: .principal) {
                        HStack {
                            Text("Scans")
                                .font(.custom(
                                    "Magnolia Script",
                                    fixedSize: 32))
                                .foregroundStyle(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .allowsTightening(true)
                                .accessibilityIdentifier("ToolbarTitle")
                            Spacer()
                        }
                    }
                    
                    if storeKitManager.subscriptionStatusIsKnownAndNotSubscribed {
                        ToolbarItem(placement: .topBarTrailing) {
                            PremiumButton(showStore: $showStore)
                                .accessibilityIdentifier("PremiumToolbarButton")
                        }
                    }
                    
                    ToolbarSpacer(.fixed, placement: .topBarTrailing)

                    ToolbarItemGroup(placement: .topBarTrailing) {
                        AddScanButtonView(showScanSheet: $showScanSheet)
                            .tint(.white)
                    }
                    ToolbarSpacer(.fixed, placement: .topBarTrailing)
                    ToolbarItemGroup(placement: .primaryAction) {
                        SettingsButtonView(selectedScanType: $selectedScanType)
                    }
                }
                .toolbarBackground(.hidden, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .tint(.white)
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
