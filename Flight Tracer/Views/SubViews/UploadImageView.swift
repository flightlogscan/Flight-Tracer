//
//  UploadImageView.swift
//  Flight Tracer
//
//  Created by William Janis on 7/27/23.
//

import SwiftUI

struct UploadImageView: View {
    
    @Binding var selectedImage: UIImage?
    @Binding var isPickerShowing: Bool
    
    var body: some View {
        if (selectedImage == nil) {
            Button {
                isPickerShowing = true
            } label: {
                (Text(Image(systemName: "square.and.arrow.up.circle.fill")) + Text("\n") + Text("Upload photo"))
                    .padding(80)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .imageScale(.large)
                    
            }
            .foregroundColor(Color.black)
            .sheet(isPresented: $isPickerShowing) {
                ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
            }
        } else {
            Image(uiImage: selectedImage!)
                .resizable()
                .cornerRadius(10)
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 200)
                .opacity(0.3)
                .overlay (alignment: .center){
                    Button {
                        selectedImage = nil
                        isPickerShowing = true
                    } label: {
                        (Text(Image(systemName: "square.and.arrow.up.circle.fill")) + Text("\n") + Text("Upload photo"))
                            .cornerRadius(10)
                            .imageScale(.large)
                    }
                    .foregroundColor(Color.black)
                }
            
            
        }
    }
}
