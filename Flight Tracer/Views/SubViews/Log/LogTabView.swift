import SwiftUI

struct LogTabView: View {
    let rows: [RowDTO]
    let rowIndex: Int
    
    @State private var fieldNameValues: [String: String] = [:]
    @State private var fieldContentValues: [String: String] = [:]
    @State private var fieldGroupNames: [String: String] = [:]
    
    @StateObject var logTabViewModel = LogTabViewModel()
    
    var fieldNames: [String: String] {
        let headerRow = rows.first(where: { $0.header })?.content ?? [:]
        return headerRow
    }
    
    var parentHeaders: [String: String] {
        let currentRow = rows.first(where: { $0.rowIndex == rowIndex && !$0.header })
        return currentRow?.parentHeaders ?? [:]
    }
    
    var rowContent: [String: String] {
        var combined: [String: String] = [:]
        rows.filter({ !$0.header }).forEach { row in
            combined.merge(row.content) { current, _ in current }
        }
        return combined
    }
    
    // Group field keys by their parent headers while preserving order, filtering out redundant parent headers
    var orderedFieldGroups: [(String?, [String])] {
        var result: [(String?, [String])] = []
        var currentGroup: [String] = []
        var currentParent: String? = nil

        let sortedKeys = fieldNames.keys.sorted { (Int($0) ?? 0) < (Int($1) ?? 0) }

        for key in sortedKeys {
            let fieldName = fieldNameValues[key] ?? fieldNames[key] ?? ""
            let parent = fieldGroupNames[key]

            let normalizedField = fieldName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            let normalizedParent = parent?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

            let isRedundant = (normalizedField == normalizedParent)
            let effectiveParent = isRedundant ? nil : parent

            let shouldGroupWithPrevious = (effectiveParent == currentParent) || (effectiveParent == nil && currentParent == nil)

            if shouldGroupWithPrevious {
                currentGroup.append(key)
            } else {
                if !currentGroup.isEmpty {
                    result.append((currentParent, currentGroup))
                }
                currentGroup = [key]
                currentParent = effectiveParent
            }
        }

        if !currentGroup.isEmpty {
            result.append((currentParent, currentGroup))
        }

        return result
    }
    
    var body: some View {
        VStack {
            Text("Row \(rowIndex)")
                .font(.headline)
            List {
                ForEach(orderedFieldGroups, id: \.1) { groupKey, keys in
                    Section(header:
                        (groupKey?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == keys.first.flatMap { fieldNameValues[$0] ?? fieldNames[$0] }?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased())
                        ? AnyView(EmptyView())
                        : AnyView(Text(groupKey ?? "").foregroundColor(.gray))
                    ) {
                        ForEach(keys, id: \.self) { key in
                            rowView(for: key)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .onAppear {
                initializeLocalState()
                logTabViewModel.setEditableData(from: rows)
            }
            .scrollDismissesKeyboard(.immediately)
        }
    }
    
    @ViewBuilder
    private func rowView(for key: String) -> some View {
        HStack {
            TextField("", text: Binding(
                get: { fieldNameValues[key] ?? "" },
                set: { newValue in
                    fieldNameValues[key] = newValue
                    logTabViewModel.updateFieldName(oldKey: key, newName: newValue)
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
                    logTabViewModel.updateField(rowIndex: rowIndex, fieldKey: key, newValue: newValue)
                }
            ))
            .font(.footnote)
            .multilineTextAlignment(.trailing)
            .foregroundColor(.white)
        }
        .padding(.vertical, 4)
    }
    
    private func initializeLocalState() {
        // Initialize field names
        for key in fieldNames.keys {
            let value: String
            if let editableData = logTabViewModel.editableLogData {
                value = editableData.getFieldName(key: key)
            } else {
                value = fieldNames[key] ?? ""
            }
            fieldNameValues[key] = value
        }
        
        // Initialize field values
        for key in fieldNames.keys {
            let value: String
            if let editableData = logTabViewModel.editableLogData {
                value = editableData.getValue(rowIndex: rowIndex, key: key)
            } else {
                value = rowContent[key] ?? ""
            }
            fieldContentValues[key] = value
        }
        
        // Initialize parent headers (group names)
        for (key, value) in parentHeaders {
            fieldGroupNames[key] = value
        }
    }
}
