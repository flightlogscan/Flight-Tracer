//
//  WillImageView.swift
//  Flight Tracer
//
//  Created by William Janis on 7/6/23.
//

import Foundation
import SwiftUI

struct ScannableImageView: View {
    
    let image: UIImage?
    @State var imageText: String = "initial state"
    
    var body: some View {
        NavigationView {
            VStack {
                if let image = image {
                    Image( uiImage: image )
                        .resizable()
                        .frame(width: 420, height: 420)
                    Button {
                        let imageTextRecognizer = ImageTextRecognizer(imageText: $imageText)
                        imageTextRecognizer.scanImageForText(image: image)
                    } label: {
                        Text("Scan text")
                    }
                    Text(imageText)
                } else {
                    Text("Missing image")
                }
            }
        }
    }
}
