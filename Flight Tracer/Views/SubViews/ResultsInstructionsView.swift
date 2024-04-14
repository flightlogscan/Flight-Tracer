//
//  HelpfulHintsView.swift
//  Flight Tracer
//
//  Created by William Janis on 7/29/23.
//

import SwiftUI

struct ResultsInstructionsView: View {
    
    var body: some View {
        VStack (alignment: .leading, spacing: 5){
            Text("Scan successful! Follow these steps next:")
                .font(.subheadline)
                .foregroundColor(Color.green)
                .fontWeight(.bold)
                .padding([.top])
            HStack {
                Image(systemName: "circle.fill").foregroundColor(Color.black).fontWeight(.bold)
                Text("Review the flight log below")
            }
            HStack {
                Image(systemName: "circle.fill").foregroundColor(Color.black).fontWeight(.bold)
                Text("Make any corrections or edits as needed")
            }
            HStack {
                Image(systemName: "circle.fill").foregroundColor(Color.black).fontWeight(.bold)
                Text("Download the flight log")
            }
            HStack {
                Image(systemName: "circle.fill").foregroundColor(Color.black).fontWeight(.bold)
                Text("Submit the downloaded file to your flight log software of choice")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.leading, .top])
    }
}

#Preview {
    UploadPageView(user: Binding.constant(nil))
}
