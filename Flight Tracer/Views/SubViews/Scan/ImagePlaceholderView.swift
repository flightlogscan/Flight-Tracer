import SwiftUI

struct ImagePlaceholderView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding([.leading, .trailing])
                .shadow(radius: 5)
            
            Text("Please select a photo")
                .font(.title3)
                .foregroundColor(.semiTransparentBlack)
        }
    }
}
