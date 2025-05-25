import SwiftUI

struct LogsView: View {
    let rows: [RowDTO]
    
    var groupedRows: [Int: [RowDTO]] {
        guard let headerRow = rows.first(where: { $0.header }) else {
            return Dictionary(grouping: rows.filter { !$0.header }) { $0.rowIndex }
        }

        let dataRows = Dictionary(grouping: rows.filter { !$0.header }) { $0.rowIndex }

        var result: [Int: [RowDTO]] = [:]
        for (index, rows) in dataRows {
            result[index] = [headerRow] + rows
        }
        return result
    }

    var body: some View {
        TabView {
            if !groupedRows.isEmpty {
                ForEach(Array(groupedRows.keys).sorted(), id: \.self) { rowIndex in
                    if let rows = groupedRows[rowIndex] {
                        LogTabView(
                            rows: rows,
                            rowIndex: rowIndex,
                        )
                    }
                }
            } else {
                ProgressView()
                    .foregroundColor(.white)
                    .padding()
                    .background(.black)
                    .cornerRadius(10)
                    .zIndex(1)
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
}
