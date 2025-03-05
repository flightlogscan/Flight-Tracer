import SwiftUI
import FirebasePerformance

struct ExportButtonView: View {
    @ObservedObject var logSwiperViewModel: LogSwiperViewModel
    @EnvironmentObject var storeKitManager: StoreKitManager
    @State var showSubscription = false

    var body: some View {
        Group {
            if storeKitManager.isSubscribed() {
                ShareLink(
                    item: logSwiperViewModel.convertLogRowsToCSV(),
                    preview: SharePreview(
                        "flight_log.csv",
                        image: Image("logoicon")
                    )
                ) {
                    Text("Export")
                        .font(.headline)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 7.5)
                        .foregroundColor(.black)
                        .background(.thinMaterial)
                        .environment(\.colorScheme, .light)
                        .clipShape(Capsule())
                }
                .accessibilityIdentifier("ExportButton")
            } else {
                Button {
                    showSubscription = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .frame( width: 36, height: 36)
                        .foregroundColor(.semiTransparentBlack)
                        .background(
                            Circle()
                                .fill(.thickMaterial)
                                .environment(\.colorScheme, .light)
                        )
                }
                .accessibilityIdentifier("UnsubscribedExportButton")
            }
        }
        .sheet(isPresented: $showSubscription) {
            CustomSubscriptionStoreView()
        }
    }
}
