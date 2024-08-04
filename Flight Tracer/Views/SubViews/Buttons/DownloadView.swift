import SwiftUI

struct DownloadView: View {
    
    @Binding var data: [[String]]
    var body: some View {
        Button {
            if let fileURL = CSVManager.createCSVFile(data, filename: "flight_log.csv") {
                let documentPicker = UIDocumentPickerViewController(forExporting: [fileURL])
                let scenes = UIApplication.shared.connectedScenes
                let windowScene = scenes.first as? UIWindowScene
                let window = windowScene?.windows.first
                window?.rootViewController?.present(documentPicker, animated: true)
            }
        } label: {
            Label("", systemImage: "square.and.arrow.down")
        }
    }
}
