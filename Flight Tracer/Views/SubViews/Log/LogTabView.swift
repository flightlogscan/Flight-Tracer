import SwiftUI

struct LogTabView: View {
    @Binding var logRow: EditableRow
    @Binding var headerRow: EditableRow

    @FocusState private var focused: Field?
    private enum Field: Hashable { case header(String), value(String) }

    var body: some View {
        VStack {
            Text("Row \(logRow.rowIndex)")
                .font(.headline)

            List {
                ForEach(
                    headerRow.content.keys.sorted { Int($0) ?? 0 < Int($1) ?? 0 },
                    id: \.self
                ) { key in
                    HStack(spacing: 12) {
                        TextField(
                            "",
                            text: Binding(
                                get: { headerRow.content[key, default: "" ] },
                                set: { headerRow.content[key] = $0 }
                            ),
                            prompt: Text("Value").foregroundStyle(.secondary)
                        )
                        .font(.footnote.weight(.semibold))
                        .focused($focused, equals: .header(key))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .layoutPriority(1)

                        TextField(
                            "",
                            text: Binding(
                                get: { logRow.content[key, default: "" ] },
                                set: { logRow.content[key] = $0 }
                            ),
                            prompt: Text("Value").foregroundStyle(.secondary)
                        )
                        .font(.footnote)
                        .multilineTextAlignment(.trailing)
                        .focused($focused, equals: .value(key))
                        .fixedSize(horizontal: true, vertical: false)
                    }
                    .padding(.vertical, 6)
                }
            }
            .scrollContentBackground(.hidden)
            .scrollDismissesKeyboard(.immediately)
        }
    }
}
