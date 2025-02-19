import SwiftUI
import FirebasePerformance

struct DownloadView: View {
    @ObservedObject var logSwiperViewModel: LogSwiperViewModel
    @EnvironmentObject var storeKitManager: StoreKitManager
    @State var showSubscription = false

    var body: some View {
        Button {
            if storeKitManager.isSubscribed() {
                let trace = Performance.startTrace(name: "DownloadButton")
                let logData = logSwiperViewModel.processRows()
                if let fileURL = CSVCreator.createCSVFile(logData, filename: "flight_log.csv") {
                    let documentPicker = UIDocumentPickerViewController(forExporting: [fileURL])
                    let scenes = UIApplication.shared.connectedScenes
                    let windowScene = scenes.first as? UIWindowScene
                    let window = windowScene?.windows.first
                    window?.rootViewController?.present(documentPicker, animated: true)
                    trace?.incrementMetric("Download", by: 1)
                    trace?.stop()
                }
            } else {
                showSubscription = true
            }
        } label: {
            Label("", systemImage: "square.and.arrow.up")
        }
        .accessibilityIdentifier("DownloadButton")
        .sheet(isPresented: $showSubscription) {
            CustomSubscriptionStoreView()
        }
    }
}
