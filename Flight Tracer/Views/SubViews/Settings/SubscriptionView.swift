import SwiftUI

struct SubscriptionView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedPlan: SubscriptionPlan = .monthly
    
    enum SubscriptionPlan {
        case monthly
        case yearly
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                SubscriptionOptionCard(
                    title: "Yearly",
                    price: "$99.99",
                    period: "year",
                    subtitle: "Save 17%",
                    isSelected: selectedPlan == .yearly
                )
                .onTapGesture { selectedPlan = .yearly }
                
                SubscriptionOptionCard(
                   title: "Monthly",
                   price: "$9.99",
                   period: "month",
                   subtitle: "Start 7-day free trial",
                   isSelected: selectedPlan == .monthly
                )
                .onTapGesture { selectedPlan = .monthly }
                
                Text(.init("By clicking \"Purchase\" you agree to the [Terms of Service](https://www.flightlogtracer.com/terms) and [Privacy Policy](https://www.flightlogtracer.com/privacy). What you are purchasing is a recurring subscription, which means we'll charge your Apple ID account today and continue to charge you \(selectedPlan) until you cancel. You can cancel at any time up to 24 hours before your current period ends in the App Store Settings."))
                    .foregroundColor(.secondary)
                    .font(.footnote)
                    .tint(.blue)
                
                Spacer()
                Text("7-day free trial, then")
                   .foregroundColor(.secondary)
                   .font(.subheadline)
                Button(action: {
                   // StoreKit purchase implementation
                }) {
                   Text("Purchase")
                       .font(.headline)
                       .foregroundColor(.white)
                       .frame(maxWidth: .infinity)
                       .padding()
                       .background(Color.navyBlue)
                       .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.top, 20)
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray, .gray.opacity(0.2))
                            .imageScale(.medium)
                            .font(.system(size: 28))
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Subscription")
                        .font(.system(size: 20, weight: .semibold))
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Restore") {
                        // Restore action
                    }
                    .foregroundStyle(Color.navyBlue)
                }
            }
        }
    }
}

struct SubscriptionOptionCard: View {
    let title: String
    let price: String
    let period: String
    var subtitle: String? = nil
    let isSelected: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            HStack(alignment: .firstTextBaseline) {
                Text(price)
                    .font(.title)
                    .fontWeight(.bold)
                Text("/ \(period)")
                    .foregroundColor(.secondary)
            }
            if let subtitle = subtitle {
                Text(subtitle)
                    .foregroundColor(.green)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(isSelected ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
    }
}
