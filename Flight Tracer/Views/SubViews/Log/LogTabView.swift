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
                    HStack(alignment: .top, spacing: 16) {
                        AutoSizingTextEditor(
                            text: Binding(
                                get: { headerRow.content[key, default: ""] },
                                set: { newValue in
                                    headerRow.content[key] = newValue
                                }
                            )
                        )
                        .font(.footnote)
                        .foregroundColor(.white)
                        .background(Color.clear)
                        .frame(minHeight: 20)
                        .frame(maxWidth: .infinity, alignment: .leading)

                        TextField("", text: Binding(
                            get: { logRow.content[key, default: ""] },
                            set: { newValue in
                                logRow.content[key] = newValue
                            }
                        ))
                        .font(.footnote)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.white)
                        .padding(4)
                        .frame(width: 80) // fixed width for right column
                        .background(Color.clear)
                        .cornerRadius(5)
                    }
                    .padding(.vertical, 4)
                }
            }
            .scrollContentBackground(.hidden)
            .scrollDismissesKeyboard(.immediately)
        }
    }
}

struct AutoSizingTextEditor: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textColor = UIColor.white
        textView.font = UIFont.preferredFont(forTextStyle: .footnote)
        textView.delegate = context.coordinator
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func textViewDidChange(_ textView: UITextView) {
            text = textView.text
        }
    }
}
