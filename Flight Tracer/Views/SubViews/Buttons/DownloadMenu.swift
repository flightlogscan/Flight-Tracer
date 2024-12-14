import SwiftUI
import FirebasePerformance

struct DownloadView: View {
    let rowViewModels: [LogRowViewModel]
    @State private var isICloudEnabled: Bool = false

    var body: some View {
        Button {
            let trace = Performance.startTrace(name: "DownloadButton")
            if let fileURL = CSVManager.createCSVFile(toArray(rowViewModels: rowViewModels), filename: "flight_log.csv") {
                let documentPicker = UIDocumentPickerViewController(forExporting: [fileURL])
                let scenes = UIApplication.shared.connectedScenes
                let windowScene = scenes.first as? UIWindowScene
                let window = windowScene?.windows.first
                window?.rootViewController?.present(documentPicker, animated: true)
                trace?.incrementMetric("Download", by: 1)
                trace?.stop()
            }
        } label: {
            Label("", systemImage: isICloudEnabled ? "icloud.and.arrow.down" : "tray.and.arrow.down")
        }
        .accessibilityIdentifier("DownloadMenuButton")
        .onAppear {
            checkICloudStatus()
        }
    }

    private func checkICloudStatus() {
        isICloudEnabled = FileManager.default.ubiquityIdentityToken != nil
    }
}
