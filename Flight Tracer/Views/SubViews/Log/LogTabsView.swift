import SwiftUI

struct LogTabsView: View {
    @Binding var editableLog: EditableLog

    private var headerIndex: Int? {
        editableLog.editableRows.firstIndex(where: { $0.header })
    }

    var body: some View {
        TabView {
            ForEach(
                editableLog.editableRows
                    .indices
                    .filter { !editableLog.editableRows[$0].header }
                    .sorted { editableLog.editableRows[$0].rowIndex < editableLog.editableRows[$1].rowIndex },
                id: \.self
            ) { index in
                if let headerIndex = headerIndex {
                    LogTabView(
                        logRow: $editableLog.editableRows[index],
                        headerRow: $editableLog.editableRows[headerIndex]
                    )
                } else {
                    //TODO: Real error handling
                    Text("Error headers not found")
                }
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
}
