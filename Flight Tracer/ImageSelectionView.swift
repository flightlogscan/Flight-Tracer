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
    @Binding var selectedImage: UIImage?
    
    var body: some View {
        VStack(spacing: 69) {
            Text("Scan your flight log")
            
            Button {
                isPickerShowing = true
            } label: {
                Text("Select a Photo")
            }
            .sheet(isPresented: $isPickerShowing) {
                ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
            }
            
            Button {
                isTakerShowing = true
            } label: {
                Text("Take a Photo")
            }
            .sheet(isPresented: $isTakerShowing) {
                ImageTaker(selectedImage: $selectedImage, isTakerShowing: $isTakerShowing)
            }
        }
    }
}
