import SwiftUI

struct CarouselSkeleton: View {
    
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
        .foregroundColor(.semiTransparentBlack)
        .alert("Allow access?", isPresented: $showAlert) {
            SettingsAlert()
        } message: {
            Text("Flight Log Tracer needs Camera Roll access to display preview photos.")
        }
    }
}
