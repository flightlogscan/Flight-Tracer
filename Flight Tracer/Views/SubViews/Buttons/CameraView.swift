import SwiftUI
import AVFoundation

struct CameraView: View {
    
    let color = Color.black.opacity(0.7)
    @Binding var selectedImage: ImageDetail
    @State private var showCamera: Bool = false
    @State private var showAlert: Bool = false
    @State private var hasPermission: Bool = false
    
    var body: some View {
        Button {
            if (hasPermission) {
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
            Button ("Open Settings") {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
            Button ("Cancel") {
            }
        } message: {
            Text("Flight Log Tracer needs Camera access to take photos.")
        }
        .cornerRadius(10)
        .aspectRatio(1, contentMode: .fit)
        .foregroundColor(color)
        .onAppear {
            requestPermission()
        }
        .fullScreenCover(isPresented: $showCamera) {
            ImageTaker(selectedImage: $selectedImage)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black)
        }
    }
    
    func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            DispatchQueue.main.async {
                hasPermission = accessGranted
            }
        })
    }
}



#Preview {
    UploadPageView(user: Binding.constant(nil))
}
