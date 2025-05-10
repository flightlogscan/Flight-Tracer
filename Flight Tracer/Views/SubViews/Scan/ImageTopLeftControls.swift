import SwiftUI

struct ImageTopLeftControls: View {
    @ObservedObject var parentViewModel: ScanViewModel
    @State private var showSavedToast = false
    @State private var didSave = false
    @State private var imageWasSaved = false
    
    var body: some View {
        Group {
            if !parentViewModel.validationInProgress {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 0) {
                        Button {
                            parentViewModel.resetImage()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .foregroundStyle(Color.primary, .regularMaterial)
                        }
                        .accessibilityElement()
                        .accessibilityIdentifier("ClearImageButton")

                        sharedImageControls()

                        if parentViewModel.selectedImage.hasError {
                            Button {
                                parentViewModel.showAlert = true
                            } label: {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundStyle(.white, .red)
                                    .font(.title)
                            }
                        }
                    }
                    .offset(x: 25, y: 5)

                    if showSavedToast {
                        Text("Saved!")
                            .font(.caption)
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                            .padding(6)
                            .background(.regularMaterial)
                            .cornerRadius(8)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                            .padding(.leading, 25)
                            .padding(.top, 4)
                    }
                }
            }
        }
        .onChange(of: parentViewModel.selectedImage.uiImage) { _, _ in
            imageWasSaved = false
        }
    }

    @ViewBuilder
    private func sharedImageControls() -> some View {
        CropperView(selectedImage: $parentViewModel.selectedImage)

        if !imageWasSaved {
            Button {
                if let uiImage = parentViewModel.selectedImage.uiImage {
                    UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
                    didSave = true
                    showSavedToast = true
                    imageWasSaved = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        showSavedToast = false
                        didSave = false
                    }
                }
            } label: {
                Image(systemName: didSave ? "checkmark.circle.fill" : "arrow.down.circle.fill")
                    .font(.title)
                    .foregroundStyle(Color.primary, .regularMaterial)
            }
            .accessibilityElement()
            .accessibilityIdentifier("DownloadImageButton")
        }
    }
}
