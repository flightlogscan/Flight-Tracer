import SwiftUI
import FirebasePerformance

struct DownloadView: View {
    
    let rowViewModels: [LogRowViewModel]

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
            Text("Download CSV")
        }
    }
    
    private func toArray(rowViewModels: [LogRowViewModel]) -> [[String]] {
        let fieldNamesRow = LogMetadataLoader.getLogMetadata(named: "JeppesenLogFormat").map { $0.fieldName }
        let logRows = rowViewModels.map { $0.fields }
    
        print("logRows: \(logRows)")

        return [fieldNamesRow] + logRows
    }
}
