import AVFoundation

class CameraPermissionManager: ObservableObject {
    
    @Published var hasPermission: Bool = false

    func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { accessGranted in
            DispatchQueue.main.async {
                self.hasPermission = accessGranted
            }
        }
    }
}
