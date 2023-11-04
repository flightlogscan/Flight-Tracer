//
//  TableTextFieldStyle.swift
//  Flight Tracer
//
//  Created by Wilbur 😎 on 11/4/23.
//

import SwiftUI

struct TableTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .font(.system(size: 11, weight: .regular, design: .default))
    }
}
