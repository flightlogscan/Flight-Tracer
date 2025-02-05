import SwiftUI
import StoreKit

struct SubscriptionPopup: View {
    @State private var showSubscription = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Unlock Flight Log Scan!")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color.primary)
            
            VStack(alignment: .leading, spacing: 16) {
                BenefitRow(icon: "doc.viewfinder", text: "Automatically convert handwritten logs to text")
                BenefitRow(icon: "pencil", text: "Review and edit text to add any finishing touches")
                BenefitRow(icon: "icloud.and.arrow.up", text: "Upload scanned logs to the cloud")
                BenefitRow(icon: "gift", text: "Try for free for 7 days!")
            }
            
            Button(action: {
                showSubscription = true
            }) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.navyBlue)
                    .cornerRadius(12)
            }
            .sheet(isPresented: $showSubscription) {
                CustomSubscriptionStoreView()
            }
        }
        .padding(24)
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(12)
        .shadow(radius: 10)
        .padding(.horizontal, 20)
    }
}

struct BenefitRow: View {
    let  icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 24, height: 24)
            Text(text)
                .font(.system(size: 16))
                .opacity(0.9)
        }
    }
}
