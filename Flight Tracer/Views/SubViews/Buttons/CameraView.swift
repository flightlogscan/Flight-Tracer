import SwiftUI
import AVFoundation

struct CameraView: View {
    
    let color = Color.black.opacity(0.7)
    @Binding var selectedImage: ImageDetail
    @State private var showCamera: Bool = false
    @State private var showAlert: Bool = false
    @StateObject private var permissionManager = CameraPermissionManager()
    
    var body: some View {
        Button {
            if permissionManager.hasPermission {
                showCamera = true
            } else {
                showAlert = true
            }
        } label: {
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .overlay (
                    Image(systemName: "camera.fill")
                        .foregroundColor(color)
                )
                .foregroundColor(.white)
        }
        .alert("Allow access?", isPresented: $showAlert) {
            SettingsAlert()
        } message: {
            Text("Flight Log Tracer needs Camera access to take photos.")
        }
        .cornerRadius(10)
        .aspectRatio(1, contentMode: .fit)
        .foregroundColor(color)
        .onAppear {
            permissionManager.requestPermission()
        }
        .fullScreenCover(isPresented: $showCamera) {
            ImageTaker(selectedImage: $selectedImage)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black)
        }
    }
}
