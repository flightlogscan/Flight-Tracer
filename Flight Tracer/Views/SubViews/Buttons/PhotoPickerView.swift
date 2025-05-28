import SwiftUI
import Photos

struct PhotoPickerView: View {
    
    @StateObject private var photoPickerViewModel = PhotoPickerViewModel()
    
    @Binding var selectedImage: ImageDetail
    
    private enum Constants {
        static let iconSize: CGFloat = 18
        static let iconWeight: Font.Weight = .medium
        static let horizontalPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 12
    }

    var body: some View {
        VStack {
            Button(action: {
                photoPickerViewModel.checkPermissionsAndShowPicker()
            }) {
                Image(systemName: "photo.on.rectangle")
                    .font(.system(size: Constants.iconSize, weight: Constants.iconWeight))
                    .foregroundColor(.semiTransparentBlack)
                    .padding(.horizontal, Constants.horizontalPadding)
                    .padding(.vertical, Constants.verticalPadding)
            }
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
