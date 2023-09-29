//
//  Emptytest.swift
//  Flight Tracer
//
//  Created by Wilbur 😎 on 9/24/23.
//

import SwiftUI

struct Emptytest: View {
    @State var isClicked = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Button {
                    isClicked = true
                } label: {
                    Text("go to table")
                }
            }
            .navigationDestination(isPresented: $isClicked) {
                ExperimentalTable()
            }
        }
    }
}
