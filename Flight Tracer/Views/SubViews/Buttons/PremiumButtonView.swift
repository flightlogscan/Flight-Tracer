import SwiftUI

struct PremiumButton: View {
    @Binding var showStore: Bool

    var body: some View {
        Button(action: { showStore = true }) {
            Circle()
                .fill(Color.purple)
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: "crown.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.yellow)
                )
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .contentShape(Circle())
        .environment(\.colorScheme, .light)
        .premiumSheet(isPresented: $showStore) {
            FLSStoreView()
        }
    }
}

#Preview {
    ScansView()
        .environmentObject(AuthManager())
        .environmentObject(StoreKitManager())
}
