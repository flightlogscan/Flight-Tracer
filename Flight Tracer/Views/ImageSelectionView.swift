//
//  ImageSelectionView.swift
//  Flight Tracer
//
//  Created by William Janis on 7/17/23.
//
import SwiftUI

struct ImageSelectionView: View {
    
    @Binding var isPickerShowing: Bool
    @Binding var isTakerShowing: Bool
    @Binding var leftImage: UIImage?
    @Binding var rightImage: UIImage?
    
    var body: some View {
        VStack(spacing: 69) {
            Text("Scan your flight log!")
//            
//            Button {
//                isPickerShowing = true
//            } label: {
//                Text("Select a Photo for left side")
//            }
//            .sheet(isPresented: $isPickerShowing) {
//                ImagePicker(selectedImage: $leftImage, isPickerShowing: $isPickerShowing)
//            }
//            
//            Button {
//                isPickerShowing = true
//            } label: {
//                Text("Select a Photo for right side")
//            }
//            .sheet(isPresented: $isPickerShowing) {
//                ImagePicker(selectedImage: $rightImage, isPickerShowing: $isPickerShowing)
//            }
            
//            Button {
//                isTakerShowing = true
//            } label: {
//                Text("Take a Photo")
//            }
//            .sheet(isPresented: $isTakerShowing) {
//                ImageTaker(selectedImage: $selectedImage, isTakerShowing: $isTakerShowing)
//            }
        }
    }
}
