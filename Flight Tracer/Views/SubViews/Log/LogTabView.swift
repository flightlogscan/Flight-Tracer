import SwiftUI

struct LogTabView: View {
    let rows: [RowDTO]
    let rowIndex: Int
    
    @State private var fieldNameValues: [String: String] = [:]
    @State private var fieldContentValues: [String: String] = [:]
    @State private var fieldGroupNames: [String: String] = [:]
    
    @ObservedObject var logSwiperViewModel: LogSwiperViewModel
    
    // Get field names from the header row
    var fieldNames: [String: String] {
        let headerRow = rows.first(where: { $0.header })?.content ?? [:]
        return headerRow
    }
    
    // Get the parent headers (categories) for grouping
    var parentHeaders: [String: String] {
        // Get parent headers from the current data row, or default to empty dictionary
        let currentRow = rows.first(where: { $0.rowIndex == rowIndex && !$0.header })
        return currentRow?.parentHeaders ?? [:]
    }
    
    // Get content from the data rows
    var rowContent: [String: String] {
        var combined: [String: String] = [:]
        rows.filter({ !$0.header }).forEach { row in
            combined.merge(row.content) { current, _ in current }
        }
        return combined
    }
    
    // Group field keys by their parent headers while preserving order
    var orderedFieldGroups: [(String, [String])] {
        var groups: [String: [String]] = [:]
        var groupOrder: [String] = []
        
        // Process keys in numeric order to maintain original sequence
        let sortedKeys = fieldNames.keys.sorted { (Int($0) ?? 0) < (Int($1) ?? 0) }
        
        for key in sortedKeys {
            let parentKey = parentHeaders[key] ?? "Other"
            
            // Track the order in which we first see each parent key
            if groups[parentKey] == nil {
                groupOrder.append(parentKey)
                groups[parentKey] = []
            }
            
            groups[parentKey]?.append(key)
        }
        
        // Return the groups in the original order they appeared
        return groupOrder.map { ($0, groups[$0] ?? []) }
    }
    
    var body: some View {
        VStack {
            Text("Row \(rowIndex)")
                .font(.headline)
            List {
                // Display fields organized by parent headers (categories)
                ForEach(orderedFieldGroups, id: \.0) { groupKey, keys in
                    Section(header: Text(groupKey).foregroundColor(.gray)) {
                        // Maintain original key order within each section
                        ForEach(keys, id: \.self) { key in
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
        // Initialize field names
        for key in fieldNames.keys {
            let value: String
            if let editableData = logSwiperViewModel.editableLogData {
                value = editableData.getFieldName(key: key)
            } else {
                value = fieldNames[key] ?? ""
            }
            fieldNameValues[key] = value
        }
        
        // Initialize field values
        for key in fieldNames.keys {
            let value: String
            if let editableData = logSwiperViewModel.editableLogData {
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
