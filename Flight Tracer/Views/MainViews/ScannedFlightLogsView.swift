

import SwiftUI

struct ScannedFlightLogsView: View {
    
    @State var imageText: [[String]]
    
    var body: some View {
                
        EditableLogGridView(imageText: $imageText)
        DownloadView(data: $imageText)
    }
}
