import SwiftUI
import Photos

struct PhotoPickerView: View {
    @StateObject private var viewModel = PhotoPickerViewModel()
    @Binding var selectedImage: ImageDetail

    var body: some View {
        VStack {
            Button(action: {
                viewModel.checkPermissionsAndShowPicker()
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
            .sheet(isPresented: $viewModel.showImagePicker, onDismiss: {
                viewModel.isSheetPresented = false
            }) {
                PhotoPickerViewController(selectedAsset: $viewModel.selectedAsset, showAlert: $viewModel.showAlert, alertMessage: $viewModel.alertMessage)
                    .onChange(of: viewModel.selectedAsset) { newAsset in
                        viewModel.handleSelectedAsset(newAsset)
                        selectedImage = viewModel.selectedImage!
                    }
            }
            .alert("Photo Access Issue", isPresented: $viewModel.showAlert) {
                SettingsAlert()
            } message: {
                Text(viewModel.alertMessage)
            }
        }
    }
}
