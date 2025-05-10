import SwiftUI
import StoreKit

struct FLSStoreView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var storeKitManager: StoreKitManager
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Image(systemName: "crown.fill")
                    .font(.title)
                    .foregroundColor(Color(hex: "FFD700"))
                
                Text("Flight Log Scan Premium")
                    .font(.custom("Magnolia Script", fixedSize: 24))
                    .foregroundStyle(.white)
            }
            .padding(.vertical)
            .frame(maxWidth: .infinity)
            .background(
                Color.clear.overlay(
                   LinearGradient(
                       gradient: Gradient(colors: [
                           Color(hex: "8A2BE2"),
                           Color(hex: "4B0082")
                       ]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing
                   )
               )
            )
            
            ScrollView {
                VStack(spacing: 16) {
                    ProductView(id: "com.flightlogscan.subscription.yearly")
                        .productViewStyle(.compact)
                        .tint(Color.primary)
                        .fontWeight(.bold)
                        .padding(7)
                        .overlay(
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(hex: "FFD700"),
                                                Color.purple,
                                                Color(hex: "8A2BE2"),
                                                Color.purple,
                                                Color(hex: "FFD700")]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 2
                                    )

                                Text("SAVE 52%")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color(hex: "8A2BE2"))
                                    .foregroundColor(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                                    .offset(x: 20, y: -9)
                            }
                        )
                        .onInAppPurchaseCompletion { product, result in
                            dismiss()
                            await storeKitManager.listenForTransactions()
                        }
                    
                    ProductView(id: "com.flightlogscan.subscription.monthly")
                        .productViewStyle(.compact)
                        .tint(Color.primary)
                        .onInAppPurchaseCompletion { product, result in
                            dismiss()
                            await storeKitManager.listenForTransactions()
                        }
                        .padding(7)
                }
                .padding()
            }
            
            Text(.init("By clicking \"Purchase\" or \"Subscribe\" you agree to the [Terms of Service](https://www.flightlogscan.com/terms) and [Privacy Policy](https://www.flightlogscan.com/privacy)."))
                .foregroundColor(.secondary)
                .font(.footnote)
                .tint(.blue)
                .padding(.horizontal)
        }
    }
}

#Preview {
    AuthenticatedView()
}
