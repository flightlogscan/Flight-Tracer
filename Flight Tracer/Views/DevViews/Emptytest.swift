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
                ScannedFlightLogsView(inputArray: [["test", "test2"], ["text", "text2"]])
            }
        }
    }
}

struct e_Previews: PreviewProvider {
    static var previews: some View {
        Emptytest()
    }
}
