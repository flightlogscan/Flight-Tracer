import SwiftUI
import _PhotosUI_SwiftUI

struct ImagePresentationView: View {
    
    @ObservedObject var parentViewModel: UploadPageViewModel
    
    var body: some View {
        if parentViewModel.selectedImage.isImageLoaded {
            VStack {
                ZStack {
                    // Invisible rectangle underneath photo to keep spacing
                    Rectangle()
                        .foregroundColor(.clear)
                        .padding([.leading, .trailing])
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
                    
                    parentViewModel.selectedImage.image!
                        .logImageStyle()
                        .overlay(
                            Group {
                                if !parentViewModel.validationInProgress {
                                    Button {
                                        parentViewModel.resetImage()
                                    } label: {
                                        Label("", systemImage: "xmark.circle.fill")
                                            .foregroundStyle(.white, .black.opacity(0.7))
                                            .font(.title)
                                            .offset(x: -15, y: 5)
                                    }
                                    .accessibilityElement()
                                    .accessibilityIdentifier("ClearImageButton")
                                }
                            },
                            alignment: .topTrailing
                        )
                        .overlay(
                            Group {
                                if parentViewModel.selectedImage.hasError && !parentViewModel.validationInProgress {
                                    HStack (spacing: 0) {
                                        Button {
                                            parentViewModel.showAlert = true
                                        } label: {
                                            Label("", systemImage: "exclamationmark.circle.fill")
                                                .foregroundStyle(.white, .red)
                                                .font(.title)
                                                .offset(x: 25, y: 5)
                                        }
                                        CropperView(selectedImage: $parentViewModel.selectedImage)
                                    }
                                } else if !parentViewModel.validationInProgress {
                                    CropperView(selectedImage: $parentViewModel.selectedImage)
                                }
                            },
                            alignment: .topLeading
                        )
                    
                    if parentViewModel.validationInProgress {
                        ProgressView()
                            .foregroundColor(.white)
                            .tint(.white)
                            .padding()
                            .background(.black)
                            .cornerRadius(10)
                            .zIndex(1)
                    }
                }
                .alert("Error detected:", isPresented: $parentViewModel.showAlert) {
                    Button ("Close") {
                    }
                } message: {
                    Text(parentViewModel.alertMessage)
                        .foregroundColor(Color.secondary)
                }
                .accessibilityIdentifier("ErrorDetectedAlert") // Added identifier for the alert
                // Runs when selected image changes
                .onReceive(parentViewModel.$selectedImage) { _ in
                    Task {
                        if (parentViewModel.selectedImage.isImageLoaded) {
                            await parentViewModel.simpleValidateImage()
                        }
                    }
                }
            }
        } else {
            ImagePlaceholderView()
        }
    }
}

#Preview {
    UploadPageView()
}
