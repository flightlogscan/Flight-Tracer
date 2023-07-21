//
//  EditableLogGrid.swift
//  Flight Tracer
//
//  Created by William Janis on 7/17/23.
//

import SwiftUI

struct EditableLogGridView: View {
    @State var imageText: [[String]]
    let frameWidth: CGFloat = 100
    let frameHeight: CGFloat = 25

    var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(0..<imageText.count, id: \.self) { rowIndex in
                    LazyHGrid(rows: [GridItem(.fixed(frameHeight))], spacing: 0) {
                        ForEach(0..<imageText[rowIndex].count, id: \.self) { columnIndex in
                            TextField("Enter text", text: $imageText[rowIndex][columnIndex])
                                .font(.system(size: 11, weight: rowIndex == 0 ? .bold : .regular, design: .default))
                                .frame(width: frameWidth, height: frameHeight, alignment: .center)
                                .background(rowIndex % 2 == 0 ? Color.gray.opacity(0.2): Color.clear)
                                .border(Color.gray, width: 1)
                        }
                    }
                    .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(.horizontal)
            
            Button {
                if let fileURL = CSVManager.createCSVFile(imageText, filename: "flight_log.csv") {
                    let documentPicker = UIDocumentPickerViewController(forExporting: [fileURL])
                    let scenes = UIApplication.shared.connectedScenes
                    let windowScene = scenes.first as? UIWindowScene
                    let window = windowScene?.windows.first
                    window?.rootViewController?.present(documentPicker, animated: true)
                }
            } label: {
                Text("Download as CSV")
            }
        }
    }
}
