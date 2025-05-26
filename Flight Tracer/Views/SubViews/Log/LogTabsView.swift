import SwiftUI

struct LogTabsView: View {
    @Binding var editableRows: [EditableRow]

    private var headerIndex: Int? {
        editableRows.firstIndex(where: { $0.header })
    }

    var body: some View {
        TabView {
            ForEach(editableRows.indices.filter { !editableRows[$0].header }, id: \.self) { index in
                if let headerIndex = headerIndex {
                    LogTabView(
                        logRow: $editableRows[index],
                        headerRow: $editableRows[headerIndex]
                    )
                } else {
                    Text("Error headers not found")
                }
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
}
