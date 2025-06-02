import AVFoundation

@MainActor
class CameraPermissionManager: ObservableObject {
    @Published var permissionStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)

    func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { accessGranted in
            Task {
                self.permissionStatus = accessGranted ? .authorized : .denied
            }
        }
    }
}
