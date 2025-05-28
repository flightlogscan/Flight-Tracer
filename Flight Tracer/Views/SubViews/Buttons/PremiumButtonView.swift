import SwiftUI

import SwiftUI

struct PremiumButton: View {
    @State private var isAnimating = false
    @Binding var showStore: Bool
    
    var body: some View {
        Button(action: {showStore = true}) {
            HStack(spacing: 6) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color(hex: "FFD700"))
                
                Text("Premium")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
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
                Capsule()
                    .stroke(Color(hex: "FFD700"), lineWidth: 1.5)
                    .opacity(0.8)
            )
            .clipShape(Capsule())
        }
        .premiumSheet(isPresented: $showStore) {
            FLSStoreView()
        }
    }
}

#Preview {
    ScansView()
}
