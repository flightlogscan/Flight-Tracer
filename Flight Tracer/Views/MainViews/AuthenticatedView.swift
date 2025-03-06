import SwiftUI
import FirebaseAuthUI
import PhotosUI

struct AuthenticatedView: View {
    @State var selectedScanType: ScanType = .api
         
    var body: some View {
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
                        PremiumButton()
                        
                        SettingsButtonView(selectedScanType: $selectedScanType)
                    }
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    AuthenticatedView()
}
