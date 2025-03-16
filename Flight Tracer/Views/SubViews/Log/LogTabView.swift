import SwiftUI

struct LogTabView: View {
    let rows: [RowDTO]
    let rowIndex: Int
    
    @State private var fieldNameValues: [String: String] = [:]
    @State private var fieldContentValues: [String: String] = [:]
    
    @ObservedObject var logSwiperViewModel: LogSwiperViewModel
    
    var fieldNames: [String: String] {
        let headerRow = rows.first(where: { $0.header })?.content ?? [:]
        return headerRow
    }
    
    var rowContent: [String: String] {
        var combined: [String: String] = [:]
        rows.filter({ !$0.header }).forEach { row in
            combined.merge(row.content) { current, _ in current }
        }
        return combined
    }
    
    var body: some View {
        VStack {
            Text("Row \(rowIndex)")
                .font(.headline)
            List {
                ForEach(Array(fieldNames.keys.sorted { (Int($0) ?? 0) < (Int($1) ?? 0) }), id: \.self) { key in
                    HStack {
                        TextField("", text: Binding(
                            get: { fieldNameValues[key] ?? "" },
                            set: { newValue in
                                fieldNameValues[key] = newValue
                                logSwiperViewModel.updateFieldName(oldKey: key, newName: newValue)
                            }
                        ))
                        .font(.footnote)
                        .bold()
                        .fixedSize(horizontal: true, vertical: true)
                        .foregroundColor(.white)
                        
                        TextField("", text: Binding(
                            get: { fieldContentValues[key] ?? "" },
                            set: { newValue in
                                fieldContentValues[key] = newValue
                                logSwiperViewModel.updateField(rowIndex: rowIndex, fieldKey: key, newValue: newValue)
                            }
                        ))
                        .font(.footnote)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.white)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .onAppear {
                initializeLocalState()
            }
            .scrollDismissesKeyboard(.immediately)
        }
    }
    
    private func initializeLocalState() {
        for key in fieldNames.keys {
            let value: String
            if let editableData = logSwiperViewModel.editableLogData {
                value = editableData.getFieldName(key: key)
            } else {
                value = fieldNames[key] ?? ""
            }
            fieldNameValues[key] = value
        }
        
        for key in fieldNames.keys {
            let value: String
            if let editableData = logSwiperViewModel.editableLogData {
                value = editableData.getValue(rowIndex: rowIndex, key: key)
            } else {
                value = rowContent[key] ?? ""
            }
            fieldContentValues[key] = value
        }
    }
}
