import SwiftUI
import AVFoundation

struct CameraView: View {
        
    @State private var showCamera: Bool = false
    @State private var showAlert: Bool = false
    @StateObject private var permissionManager = CameraPermissionManager()
    
    @Binding var selectedImage: ImageDetail
    
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
                        .foregroundColor(.semiTransparentBlack)
                )
                .foregroundColor(.white)
        }
        .alert("Allow access?", isPresented: $showAlert) {
            PhoneSettingsAlert()
        } message: {
            Text("Flight Log Tracer needs Camera access to take photos.")
        }
        .cornerRadius(10)
        .aspectRatio(1, contentMode: .fit)
        .foregroundColor(.semiTransparentBlack)
        .onAppear {
            permissionManager.requestPermission()
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraViewController(selectedImage: $selectedImage)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black)
        }
    }
}
