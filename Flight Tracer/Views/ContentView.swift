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
    @State private var areBothImagesValid : Bool = false
    @State private var showLeftWarning = false
    @State private var showRightWarning = false
    @State var leftImage: UIImage?
    @State var rightImage: UIImage?
    @State var leftImageText: [String]?
    @State var rightImageText: [String]?
    @State var leftImageData: [[String]]?
    @State var rightImageData: [[String]]?

    var body: some View {
        NavigationStack {
            VStack {
                
                let areBothImagesSelected = leftImage != nil && rightImage != nil
                Text("")
                    .navigationTitle("Flight Log Selection")

                ImageHintsView()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading])
                
                Spacer()
                UploadImageView(selectedImage: $leftImage, isPickerShowing: $isLeftPickerShowing, showWarning: true)
                Spacer()
                UploadImageView(selectedImage: $rightImage, isPickerShowing: $isRightPickerShowing, showWarning: true)
                Spacer()
                
                
                Button{
                    areBothImagesValid = validate(areBothImagesSelected: areBothImagesSelected)
                } label : {
                    Text("Scan")
                }
                .foregroundColor(areBothImagesSelected ? Color.white : Color.white.opacity(0.5))
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(areBothImagesSelected ? Color.blue : Color.gray)
                .cornerRadius(5)
                .padding()
            }
            .navigationDestination(isPresented: $areBothImagesValid) {
                EmptyView()
            }
        }
    }
    
    private func validate(areBothImagesSelected: Bool) -> Bool {
        if (!areBothImagesSelected) {
            return false
        }
        return true
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


//                NavigationLink(destination: ScannableImageView(pageSide: PageSide.left, selectedImage: $leftImage), isActive: $areBothImagesValid) {
//                    Text("Scan")
        
//                }
//                .disabled(!areBothImagesSelected)


//                .simultaneousGesture(TapGesture().onEnded{
//                        let leftImageTextRecognizer = ImageTextRecognizer(imageText: $leftImageText)
//                        leftImageTextRecognizer.scanImageForText(image: $leftImage)
//
//                        let leftRecogniedTextProcessor = RecognizedTextProcessor(processedImageText: $leftImageData)
//                        leftRecogniedTextProcessor.processText(imageText: $leftImageText)
//
//                        let rightImageTextRecognizer = ImageTextRecognizer(imageText: $rightImageText)
//                        rightImageTextRecognizer.scanImageForText(image: $rightImage)
//
//                        let rightRecogniedTextProcessor = RecognizedTextProcessor(processedImageText: $rightImageData)
//                        rightRecogniedTextProcessor.processText(imageText: $rightImageText)
    //)
