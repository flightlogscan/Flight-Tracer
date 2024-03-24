//
//  LogTableView.swift
//  Flight Tracer
//
//  Created by Wilbur 😎 on 3/24/24.
//

import SwiftUI

struct LogTableView: View {
    @Binding var imageText: [[String]]
    let frameWidth: CGFloat = 75
    let frameHeight: CGFloat = 25

    var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: true) {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                Section(header: HeaderRowView(headerRow: $imageText[0])) {
                    ForEach(1..<imageText.count, id: \.self) { rowIndex in
                        LogRowView(rowIndex: rowIndex, row: $imageText[rowIndex])
                    }
                }
            }
        }
        .onAppear {
            UIScrollView.appearance().bounces = false
        }
    }
}

struct LogRowView: View {
    let frameWidth: CGFloat = 75
    let frameHeight: CGFloat = 25
    let rowIndex: Int
    @Binding var row: [String]
    
    var body: some View {
        LazyHStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
            Section (header: RowNumberView(index: rowIndex)) {
                ForEach(0..<row.count, id: \.self) { col in
                    TextField("", text: $row[col])
                        .opacity(1.0)
                        .frame(width: frameWidth, height: frameHeight)
                        .background(Color.clear)
                        .border(Color.gray, width: 0.3)
                }
            }
        }
    }
}

struct HeaderRowView: View {
    @Binding var headerRow: [String]
    
    var body: some View {
        LazyHStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
            Section(header: CornerCell()) {
                ForEach(0..<headerRow.count, id: \.self) { cellIndex in
                    TextField("", text: $headerRow[cellIndex])
                        .font(.system(size: 11, weight: .regular, design: .default))
                        .opacity(0.8)
                        .frame(width: 75, height: 25, alignment: .center)
                        .background(Color(.systemGray5))
                        .border(Color.gray, width: 0.3)
                }
            }
        }
    }
}

struct RowNumberView: View {
    let index: Int
    
    var body: some View {
        Text(index == 0 ? "" : "\(index)")
            .font(.system(size: 11, weight: .regular, design: .default))
            .opacity(0.8)
            .frame(width: 50, height: 25, alignment: .center)
            .background(Color(.systemGray5))
            .border(Color.gray, width: 0.3)
            .zIndex(1)
    }
}

struct CornerCell: View {
    var body: some View {
        Text("")
            .font(.system(size: 11, weight: .regular, design: .default))
            .frame(width: 50, height: 25, alignment: .center)
            .background(Color(.systemGray5))
            .border(Color.gray, width: 0.3)
    }
}

