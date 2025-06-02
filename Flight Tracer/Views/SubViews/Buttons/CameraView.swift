import SwiftUI
import AVFoundation

struct CameraView: View {
    
    @State private var showCamera: Bool = false
    @State private var showAlert: Bool = false
    @StateObject private var permissionManager = CameraPermissionManager()
    
    @Binding var selectedImage: ImageDetail
    
    var body: some View {
        Button {
            switch permissionManager.permissionStatus {
            case .authorized:
                showCamera = true
            case .notDetermined:
                permissionManager.requestPermission()
            case .denied, .restricted:
                showAlert = true
            @unknown default:
                break
            }
        } label: {
            Image(systemName: "camera.circle.fill")
                .font(.system(size: 50))
                .foregroundStyle(Color.primary, .regularMaterial)
                .environment(\.colorScheme, .light)
        }
        .alert("Allow access?", isPresented: $showAlert) {
            PhoneSettingsAlert()
        } message: {
            Text("FlightLogScan needs Camera access to take photos.")
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraViewController(selectedImage: $selectedImage)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black)
        }
    }
}

#Preview {
    ScansView()
}
