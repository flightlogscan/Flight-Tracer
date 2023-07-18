//
//  EditableLogGrid.swift
//  Flight Tracer
//
//  Created by William Janis on 7/17/23.
//

import SwiftUI

struct EditableLogGridView: View {
    
    @State var imageText: [String]
    
    let verticalSpacing: CGFloat = 0
    let frameWidth: CGFloat = 200
    let frameHeight: CGFloat = 25
    let horizontalSpacing: CGFloat = 0
    let bottomPadding: CGFloat = -2
    let columns = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
    ]
    var body: some View {
        Text("Parsed Flight Log")
            .font(.system(size: 18, weight: .bold, design: .default))
            .foregroundColor(.blue)
        
        ScrollView {
            LazyVStack {
                let lastRowIndex: Int = imageText.count - 1
                LazyVGrid(columns: columns, alignment: .center, spacing: verticalSpacing) {
                    ForEach((0...lastRowIndex), id: \.self) { index in
                        let theImageText = Binding(
                            get: { imageText[index] },
                            set: { imageText[index] = $0 }
                        )
                        
                        TextField("Enter text", text: theImageText)
                            .font(.system(size: 14, weight: .regular, design: .default))
                            .frame(width: frameWidth, height: frameHeight, alignment: .center)
                            .background(.white)
                            .border(.gray, width: 1)
                            .padding(.bottom, bottomPadding)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
