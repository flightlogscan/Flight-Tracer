import SwiftUI

extension Image {
    func logImageStyle() -> some View {
        self
            .resizable()
            .scaledToFit()
            .cornerRadius(20)
            .shadow(radius: 5)
            .padding([.leading, .trailing])
    }
}
