//
//  EditableLogGrid.swift
//  Flight Tracer
//
//  Created by William Janis on 7/17/23.
//

import SwiftUI
struct EditableLogGridView: View {
    @State var imageText: [[String]] // A 2D array for grid data
    let verticalSpacing: CGFloat = 0
    let frameWidth: CGFloat = 100
    let frameHeight: CGFloat = 25
    let horizontalSpacing: CGFloat = 0
    let bottomPadding: CGFloat = -2
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                LazyVStack(spacing: verticalSpacing) {
                    ForEach(0..<imageText.count, id: \.self) { rowIndex in
                        LazyHStack(spacing: horizontalSpacing) {
                            ForEach(0..<imageText[rowIndex].count, id: \.self) { columnIndex in
                                TextField("Enter text", text: $imageText[rowIndex][columnIndex])
                                    .font(.system(size: 11, weight: rowIndex == 0 ? .bold : .regular, design: .default))
                                    .frame(width: frameWidth, height: frameHeight, alignment: .center)
                                    .background(rowIndex % 2 == 0 ? Color.gray.opacity(0.2): Color.clear)
                                    .border(Color.gray, width: 1)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
