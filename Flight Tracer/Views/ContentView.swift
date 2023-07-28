//
//  ContentView.swift
//  Flight Tracer
//
//  Created by William Janis on 7/5/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var isLeftPickerShowing = false
    @State var isRightPickerShowing = false
    @State var leftImage: UIImage?
    @State var rightImage: UIImage?
    
    var body: some View {
        let imagesSelected = leftImage != nil && rightImage != nil
        
        NavigationView {
            VStack (spacing: 10) {
                Text("")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .navigationTitle("Flight Log Selection")
                
                VStack (alignment: .leading, spacing: 5){
                    HStack {
                        Image(systemName: "checkmark").foregroundColor(Color.green).fontWeight(.bold)
                        Text("Readble, neat, and bold handwritten text")
                    }
                    HStack {
                        Image(systemName: "checkmark").foregroundColor(Color.green).fontWeight(.bold)
                        Text("Well-lit images")
                    }
                    HStack {
                        Image(systemName: "xmark").foregroundColor(Color.red).fontWeight(.bold)
                        Text("Images that are not flight logs")
                    }
                    HStack {
                        Image(systemName: "xmark").foregroundColor(Color.red).fontWeight(.bold)
                        Text("Wrinkles or tears in the log")
                    }
                    Text("File size should be 4MB or less")
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                UploadImageView(selectedImage: $leftImage, isPickerShowing: $isLeftPickerShowing)
                UploadImageView(selectedImage: $rightImage, isPickerShowing: $isRightPickerShowing)
                Spacer()
                NavigationLink(destination: ScannableImageView(pageSide: PageSide.right, selectedImage: $rightImage)) {
                    Text("Scan")
                        .foregroundColor(imagesSelected ? Color.white : Color.white.opacity(0.6))
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(imagesSelected ? Color.blue : Color.gray)
                        .cornerRadius(5)
                        .padding()
                }
                .disabled(!imagesSelected)
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
