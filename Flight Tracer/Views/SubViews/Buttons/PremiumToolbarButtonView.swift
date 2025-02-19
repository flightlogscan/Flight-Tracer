import SwiftUI

struct PremiumToolbarButtonView: View {
    @State var isSheetPresented: Bool = false

    var body: some View {
        Button {
            isSheetPresented = true
        } label: {
            Image(systemName: "crown.fill")
                .foregroundStyle(Color.gold)
        }
        .sheet(isPresented: $isSheetPresented) {
            CustomSubscriptionStoreView()
        }
        .accessibilityIdentifier("SettingsMenuButton")
    }
}
