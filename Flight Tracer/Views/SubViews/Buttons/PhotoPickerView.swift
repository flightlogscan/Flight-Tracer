import SwiftUI
import Photos

struct PhotoPickerView: View {
    
    @StateObject private var photoPickerViewModel = PhotoPickerViewModel()
    
    @Binding var selectedImage: ImageDetail

    var body: some View {
        VStack {
            Button {
                photoPickerViewModel.checkPermissionsAndShowPicker()
            } label: {
                Image(systemName: "photo.circle.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(Color.primary, .regularMaterial)
                    .environment(\.colorScheme, .light)
            }
            .accessibilityLabel("Select Photo")
            .accessibilityIdentifier("PhotoPickerButton")
            .accessibilityAddTraits(.isButton)
            .sheet(isPresented: $photoPickerViewModel.showImagePicker, onDismiss: {
                photoPickerViewModel.isSheetPresented = false
            }) {
                PhotoPickerViewController(selectedAsset: $photoPickerViewModel.selectedAsset, showAlert: $photoPickerViewModel.showAlert, alertMessage: $photoPickerViewModel.alertMessage)
                    .onChange(of: photoPickerViewModel.selectedAsset) {
                        photoPickerViewModel.handleSelectedAsset(photoPickerViewModel.selectedAsset)
                        selectedImage = photoPickerViewModel.selectedImage!
                        photoPickerViewModel.showImagePicker = false
                    }
            }
            .alert("Photo Access Issue", isPresented: $photoPickerViewModel.showAlert) {
                PhoneSettingsAlert()
            } message: {
                Text(photoPickerViewModel.alertMessage)
            }
        }
    }
}

#Preview {
    ScansView()
}
