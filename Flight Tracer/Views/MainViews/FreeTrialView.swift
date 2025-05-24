import SwiftUI
import StoreKit

struct FreeTrialView: View {
    @EnvironmentObject var storeKitManager: StoreKitManager
    let onFinished: () -> Void
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Image("flightlogbg")
                    .resizable()
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [.clear, .black]),
                            startPoint: .center,
                            endPoint: .bottom
                        )
                        .ignoresSafeArea()
                    )
                    .ignoresSafeArea()
                    .padding(.bottom)
                    .padding(.bottom)

                VStack {
                    Spacer()
                    
                    VStack {
                        Text("Digitize Your Logs")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)

                        Text("Scan your logs, stay in the air — not in paperwork.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.bottom)

                        Button("Start Scanning Logs") {
                            Task {
                                if let product = try? await Product.products(for: ["com.flightlogscan.subscription.yearly"]).first {
                                    let success = await storeKitManager.purchase(subscription: product)
                                    if success {
                                        onFinished()
                                        dismiss()
                                    }
                                }
                            }
                        }
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))

                        Text("7 days free then $39.99/year.")
                            .fixedSize(horizontal: false , vertical: true)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                    }
                }
                .padding()
                .padding()
                .padding(.bottom)
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        onFinished()
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundStyle(Color.primary, .thinMaterial)
                    }
                }
            }
        }
    }
}

#Preview {
    FreeTrialView(onFinished: {})
        .environmentObject(StoreKitManager())
}
