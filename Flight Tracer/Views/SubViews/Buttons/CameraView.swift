import SwiftUI
import AVFoundation

struct CameraView: View {
    
    private enum Constants {
        static let iconSize: CGFloat = 18
        static let iconWeight: Font.Weight = .medium
        static let horizontalPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 12
    }
    
    @State private var showCamera: Bool = false
    @State private var showAlert: Bool = false
    @StateObject private var permissionManager = CameraPermissionManager()
    
    @Binding var selectedImage: ImageDetail
    
    var body: some View {
        Button(action: {
            if permissionManager.hasPermission {
                showCamera = true
            } else {
                showAlert = true
            }
        }) {
            Image(systemName: "camera")
                .font(.system(size: Constants.iconSize, weight: Constants.iconWeight))
                .foregroundColor(.semiTransparentBlack)
                .padding(.horizontal, Constants.horizontalPadding)
                .padding(.vertical, Constants.verticalPadding)
        }
        .alert("Allow access?", isPresented: $showAlert) {
            PhoneSettingsAlert()
        } message: {
            Text("Flight Log Tracer needs Camera access to take photos.")
        }
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

#Preview {
    ScansView()
}
