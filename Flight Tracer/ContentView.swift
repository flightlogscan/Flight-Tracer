//
//  ContentView.swift
//  Flight Tracer
//
//  Created by William Janis on 7/5/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var isPickerShowing = false
    @State var isTakerShowing = false
    @State var selectedImage: UIImage?
    
    var body: some View {
        if (selectedImage == nil) {
            ImageSelectionView(isPickerShowing: $isPickerShowing,
                               isTakerShowing: $isTakerShowing,
                               selectedImage: $selectedImage)
        } else {
            ScannableImageView(selectedImage: $selectedImage)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
