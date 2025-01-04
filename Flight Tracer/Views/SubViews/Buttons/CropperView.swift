import SwiftUI

struct CropperView: View {
    @State var showCropper: Bool = false
    @Binding var selectedImage: ImageDetail
    
    var body: some View {
        Button {
            showCropper = true
        } label: {
            ZStack {
                Circle()
                    .fill(Color.black.opacity(0.7))
                    .frame(width: 30, height: 30)
               
               Image(systemName: "crop.rotate")
                   .foregroundColor(.white)
            }
            .offset(x: 25, y: 5)
        }
        .fullScreenCover(isPresented: $showCropper) {
            CropperViewController(selectedImage: $selectedImage)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black)
        }
    }
}
