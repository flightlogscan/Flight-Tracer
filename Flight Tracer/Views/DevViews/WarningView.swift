//
//  SelectImageView.swift
//  Flight Tracer
//
//  Created by Wilbur 😎 on 9/17/23.
//

import SwiftUI

struct WarningView: View {
    
    @State var images: [ImageDetail] = []
    @State var allowScan: Bool = false
    @State var scanTypeSelected: Bool = false
    @ObservedObject var contentViewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            Text("Real scan?")
                .font(Font.largeTitle)
                .bold()
                .foregroundColor(Color.red)
                .scaledToFit()
            Button{
                
                //TODO: implement the call below for image text scanning
                // This is the legit scanner that will back the ultimate output going to the user
                if (allowScan) {
                    contentViewModel.processImageText(images: images, realScan: true)
                }
                scanTypeSelected = true
            } label: {
                Label("Yes", systemImage: "checkmark.circle.fill")
                    .frame(maxWidth: .infinity)
                    .font(.title2)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
            .bold()
            .padding([.leading, .trailing])
            .scaledToFit()
            Button{
                
                //TODO: implement the call below for image text scanning
                // This is the legit scanner that will back the ultimate output going to the user
                if (allowScan) {
                    contentViewModel.processImageText(images: images, realScan: false)
                }
                scanTypeSelected = true
            } label: {
                Label("No", systemImage: "x.circle.fill")
                    .frame(maxWidth: .infinity)
                    .font(.title2)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
            .bold()
            .padding([.leading, .trailing])
            .scaledToFit()
        }.navigationDestination(isPresented: $scanTypeSelected) {
            // TODO: replace test data with results from processImageText call
            ScannedFlightLogsView(imageText: [["test", "test2"], ["text", "text2"]])
        }
    }
}

