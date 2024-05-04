import SwiftUI

struct CarouselSkeleton: View {
    
    let color = Color.black.opacity(0.7)
    
    @State private var showAlert = false
    
    var body: some View {
        Button {
            showAlert = true
        } label: {
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .foregroundColor(.white.opacity(0.5))
        }
        .cornerRadius(10)
        .aspectRatio(1, contentMode: .fit)
        .foregroundColor(color)
        .alert("Allow access?", isPresented: $showAlert) {
            Button ("Open Settings") {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
            Button ("Cancel") {
            }
        } message: {
            Text("Flight Tracer needs Camera Roll access to display preview photos.")
        }
    }
}
