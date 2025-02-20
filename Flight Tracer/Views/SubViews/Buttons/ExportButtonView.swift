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
                        "Flight Log",
                        image: "flight_log.csv"
                    )
                ) {
                    Label("", systemImage: "square.and.arrow.up")
                }
                .accessibilityIdentifier("ExportButton")
            } else {
                Button {
                    showSubscription = true
                } label: {
                    Label("", systemImage: "square.and.arrow.up")
                }
                .accessibilityIdentifier("UnsubscribedExportButton")
            }
        }
        .sheet(isPresented: $showSubscription) {
            CustomSubscriptionStoreView()
        }
    }
}
