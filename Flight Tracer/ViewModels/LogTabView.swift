import SwiftUI

struct LogTabView: View {
    let rows: [RowDTO]
    let rowIndex: Int
    @ObservedObject var logSwiperViewModel: LogSwiperViewModel
    
    @State private var fieldNameValues: [String: String] = [:]
    @State private var fieldContentValues: [String: String] = [:]
    @FocusState private var focusedField: String?
    
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
        List {
            ForEach(Array(fieldNames.keys.sorted { (Int($0) ?? 0) < (Int($1) ?? 0) }), id: \.self) { key in
                HStack(spacing: 12) {
                    TextField("Field", text: Binding(
                        get: { fieldNameValues[key] ?? "" },
                        set: { newValue in
                            fieldNameValues[key] = newValue
                            logSwiperViewModel.updateFieldName(oldKey: key, newName: newValue)
                        }
                    ))
                    .font(.system(size: 14))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white)
                    .focused($focusedField, equals: "name_\(key)")
                    
                    TextField("Value", text: Binding(
                        get: { fieldContentValues[key] ?? "" },
                        set: { newValue in
                            fieldContentValues[key] = newValue
                            logSwiperViewModel.updateField(rowIndex: rowIndex, fieldKey: key, newValue: newValue)
                        }
                    ))
                    .font(.system(size: 14))
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundColor(.white)
                    .focused($focusedField, equals: "value_\(key)")
                }
                .padding(.vertical, 4)
            }
        }
        .scrollContentBackground(.hidden)
        .onAppear {
            initializeLocalState()
        }
        .onTapGesture {
            focusedField = nil
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    focusedField = nil
                }
            }
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

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
