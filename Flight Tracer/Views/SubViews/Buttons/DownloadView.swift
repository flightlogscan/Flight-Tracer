import SwiftUI
import FirebasePerformance

struct DownloadView: View {
    
    @Binding var data: [[String]]
    var body: some View {
        Button {
            let trace = Performance.startTrace(name: "DownloadButton")
            if let fileURL = CSVManager.createCSVFile(data, filename: "flight_log.csv") {
                let documentPicker = UIDocumentPickerViewController(forExporting: [fileURL])
                let scenes = UIApplication.shared.connectedScenes
                let windowScene = scenes.first as? UIWindowScene
                let window = windowScene?.windows.first
                window?.rootViewController?.present(documentPicker, animated: true)
                trace?.incrementMetric("Download", by: 1)
                trace?.stop()
            }
        } label: {
            Text("Download CSV")
        }
    }
}
