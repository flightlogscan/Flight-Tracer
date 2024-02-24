//
//  SelectImageView.swift
//  Flight Tracer
//
//  Created by Wilbur 😎 on 9/17/23.
//

import SwiftUI

struct WarningView: View {
    
    @State var images: [ImageDetail] = []
    @State var scanTypeSelected: Bool = false
    @Binding var user: User?
    @ObservedObject var contentViewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            Text("Real scan?")
                .font(Font.largeTitle)
                .bold()
                .foregroundColor(Color.red)
                .scaledToFit()
            Button{
                
                contentViewModel.processImageText(images: images, realScan: true, user: user)
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
                contentViewModel.processImageText(images: images, realScan: false, user: user)
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
            // NOTE: Comment ScannedFlightLogsView and uncomment ExperimentalTable to use real data
            // ScannedFlightLogsView(imageText: [["test", "test2"], ["text", "text2"]])
            ExperimentalTable(imageDetail: images[0])
        }
    }
}

