import SwiftUI

struct CarouselSkeleton: View {
    
    let color = Color.black.opacity(0.7)
    
    @State private var showAlert = false
    
    var body: some View {
        Button {
            showAlert = true
        } label: {
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
//                .overlay (
//                    Image(systemName: "photo.badge.plus.fill")
//                        .foregroundColor(color)
//                )
                .foregroundColor(.white.opacity(0.5))
        }
        .cornerRadius(10)
        .aspectRatio(1, contentMode: .fit)
        .foregroundColor(color)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Allow access?"),
                message: Text("Flight Tracer needs camera roll access to display preview photos"),
                primaryButton: .default(
                    Text("Go to settings"),
                    action: {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
                ),
                secondaryButton: .default(Text("Cancel"))
            )
        }
        
    }
}
