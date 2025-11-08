import SwiftUI

struct PremiumButton: View {
    @Binding var showStore: Bool

    var body: some View {
        Button(action: {showStore = true}) {
            HStack {
                Image(systemName: "crown.fill")
                    .foregroundColor(Color(hex: "FFD700"))
                    .font(.subheadline)
                
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "8A2BE2"),  // Deep purple
                        Color(hex: "4B0082")   // Indigo
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                Circle()
                    .stroke(Color(hex: "FFD700"), lineWidth: 1.5)
                    .opacity(0.8)
            )
            .clipShape(Circle())
        }
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
