//
//  SelectImageStyle.swift
//  Flight Tracer
//
//  Created by Wilbur 😎 on 9/17/23.
//
import SwiftUI

struct SelectImageStyle: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: { configuration.trigger() }) {
            configuration.label
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(.white)
    }
}
