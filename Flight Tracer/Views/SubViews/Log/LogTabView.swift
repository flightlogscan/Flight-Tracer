import SwiftUI

struct LogTabView: View {
    @Binding var logRow: EditableRow
    @Binding var headerRow: EditableRow

    var body: some View {
        VStack {
            Text("Row \(logRow.rowIndex)")
                .font(.headline)
            List {
                ForEach(headerRow.content.keys.sorted { Int($0) ?? 0 < Int($1) ?? 0 }, id: \.self) { key in
                    HStack {
                        Text(headerRow.content[key] ?? "")
                            .font(.footnote)
                            .foregroundColor(.white)
                        Spacer()
                        TextField("Value", text: Binding(
                            get: { logRow.content[key, default: ""] },
                            set: { newValue in
                                logRow.content[key] = newValue
                            }
                        ))
                        .font(.footnote)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.white)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .scrollDismissesKeyboard(.immediately)
        }
    }
}
