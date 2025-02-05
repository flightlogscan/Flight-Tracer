import SwiftUI
import Photos

struct PhotoPickerView: View {
    
    @StateObject private var photoPickerViewModel = PhotoPickerViewModel()
    
    @Binding var selectedImage: ImageDetail

    var body: some View {
        VStack {
            Button(action: {
                photoPickerViewModel.checkPermissionsAndShowPicker()
            }) {
                Rectangle()
                    .overlay(
                        Image(systemName: "photo.fill")
                            .foregroundColor(.semiTransparentBlack)
                    )
                    .foregroundColor(.white)
            }
            .cornerRadius(10)
            .aspectRatio(1, contentMode: .fit)
            .accessibilityLabel("Select Image")
            .accessibilityIdentifier("PhotoPickerButton")
            .accessibilityAddTraits(.isButton)
            .sheet(isPresented: $photoPickerViewModel.showImagePicker, onDismiss: {
                photoPickerViewModel.isSheetPresented = false
            }) {
                PhotoPickerViewController(selectedAsset: $photoPickerViewModel.selectedAsset, showAlert: $photoPickerViewModel.showAlert, alertMessage: $photoPickerViewModel.alertMessage)
                    .onChange(of: photoPickerViewModel.selectedAsset) {
                        photoPickerViewModel.handleSelectedAsset(photoPickerViewModel.selectedAsset)
                        selectedImage = photoPickerViewModel.selectedImage!
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
