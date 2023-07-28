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
        let imagesSelected = leftImage != nil || rightImage != nil
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack (spacing: 10) {
                    Text("")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .navigationTitle("Flight Log Selection")
                    
                    VStack (alignment: .leading, spacing: 5){
                        HStack {
                            Image(systemName: "checkmark").foregroundColor(Color.green).fontWeight(.bold)
                            Text("Readable, well-lit images")
                        }
                        HStack {
                            Image(systemName: "xmark").foregroundColor(Color.red).fontWeight(.bold)
                            Text("Images that are not flight logs")
                        }
                        Spacer()
                    }
                    
                    
                    if (leftImage == nil) {
                        Button {
                            isLeftPickerShowing = true
                        } label: {
                            (Text(Image(systemName: "photo")) + Text("\n") + Text("Upload photo"))
                                .padding(100)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                        }
                        .foregroundColor(Color.gray.opacity(0.8))
                        .sheet(isPresented: $isLeftPickerShowing) {
                            ImagePicker(selectedImage: $leftImage, isPickerShowing: $isLeftPickerShowing)
                        }
                    } else {
                        Image(uiImage: leftImage!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 200)
                    }
                    
                    if (rightImage == nil) {
                        Button {
                            isRightPickerShowing = true
                        } label: {
                            (Text(Image(systemName: "photo")) + Text("\n") + Text("Upload photo"))
                                .padding(100)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                        }
                        .foregroundColor(Color.gray.opacity(0.8))
                        .sheet(isPresented: $isRightPickerShowing) {
                            ImagePicker(selectedImage: $rightImage, isPickerShowing: $isRightPickerShowing)
                        }
                    } else {
                        Image(uiImage: rightImage!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 200)
                    }
                    
                    NavigationLink(destination: ScannableImageView(pageSide: PageSide.right, selectedImage: $rightImage)) {
                        Text("Scan")
                            .foregroundColor((imagesSelected) ? Color.blue : Color.gray)
                    }.disabled(!imagesSelected)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
