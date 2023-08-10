

import SwiftUI

struct ScannedFlightLogsView: View {
    
    @State var imageText: [[String]]
    
    var body: some View {
                
        EditableLogGridView(imageText: $imageText)
        
        Button {
            if let fileURL = CSVManager.createCSVFile(imageText, filename: "flight_log.csv") {
                let documentPicker = UIDocumentPickerViewController(forExporting: [fileURL])
                let scenes = UIApplication.shared.connectedScenes
                let windowScene = scenes.first as? UIWindowScene
                let window = windowScene?.windows.first
                window?.rootViewController?.present(documentPicker, animated: true)
            }
        } label: {
            Text("Download CSV")
        }
    }
}
