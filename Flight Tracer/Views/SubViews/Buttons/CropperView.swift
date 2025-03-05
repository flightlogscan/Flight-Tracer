import SwiftUI

struct CropperView: View {
    @State var showCropper: Bool = false
    @Binding var selectedImage: ImageDetail
    
    var body: some View {
        Button {
            showCropper = true
        } label: {
            ZStack {
                Image(systemName: "circle.fill")
                    .font(.title)
                    .foregroundStyle(.regularMaterial)

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
