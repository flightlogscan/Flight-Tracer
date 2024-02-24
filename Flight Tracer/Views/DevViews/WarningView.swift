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
    @State var isDataLoaded: Bool?
    @ObservedObject var contentViewModel = ContentViewModel()
    
    var body: some View {
        ZStack {
            if (isDataLoaded == nil || !isDataLoaded!){
                Color(uiColor: Colors.NAVY_BLUE)
                    .ignoresSafeArea()
                Image(systemName: "airplane")
                    .resizable()
                    .frame(width: 150, height: 150, alignment: .center)
                    .foregroundColor(Color(uiColor: Colors.GOLD))
            } else if (!isDataLoaded!) {
                Color(uiColor: Colors.NAVY_BLUE)
                    .ignoresSafeArea()
                Image(systemName: "airplane")
                    .resizable()
                    .frame(width: 150, height: 150, alignment: .center)
                    .foregroundColor(Color(uiColor: Colors.GOLD))
            } else if (isDataLoaded!){
                ExperimentalTable(imageDetail: images[0])
            }
        }.animation(.easeInOut(duration: 0.25), value:isDataLoaded)
            .onAppear {
                self.loadData()
            }
        .navigationDestination(isPresented: $scanTypeSelected) {
            // NOTE: Comment ScannedFlightLogsView and uncomment ExperimentalTable to use real data
            // ScannedFlightLogsView(imageText: [["test", "test2"], ["text", "text2"]])
            ExperimentalTable(imageDetail: images[0])
        }
    }
    
    func loadData() {
        contentViewModel.processImageText(images: images, realScan: true, user: user)
        
        while (images[0].analyzeResult == nil) {
            isDataLoaded = false
        }
        isDataLoaded = true
    }
}

