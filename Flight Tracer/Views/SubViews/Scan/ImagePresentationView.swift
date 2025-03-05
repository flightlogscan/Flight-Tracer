import SwiftUI
import _PhotosUI_SwiftUI

struct ImagePresentationView: View {
    
    @ObservedObject var parentViewModel: ScanViewModel
    @Binding var activeScanPressed: Bool
    
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
                        .overlay (alignment: .topTrailing) {
                            if (!parentViewModel.validationInProgress) {
                                ScanButtonView(activeScanPressed: $activeScanPressed)
                            }
                        }
                        .overlay (alignment: .topLeading) {
                            Group {
                                if parentViewModel.selectedImage.hasError && !parentViewModel.validationInProgress {
                                    HStack (spacing: 0) {
                                        Button {
                                            parentViewModel.resetImage()
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .font(.title)
                                                .foregroundStyle(Color.primary, .regularMaterial)
                                                .offset(x: 25, y: 5)
                                        }
                                        .accessibilityElement()
                                        .accessibilityIdentifier("ClearImageButton")
                                        CropperView(selectedImage: $parentViewModel.selectedImage)
                                        Button {
                                            parentViewModel.showAlert = true
                                        } label: {
                                            Image(systemName: "exclamationmark.circle.fill")
                                                .foregroundStyle(.white, .red)
                                                .font(.title)
                                                .offset(x: 25, y: 5)                                            
                                        }
                                    }
                                } else if !parentViewModel.validationInProgress {
                                    HStack (spacing: 0) {
                                        Button {
                                            parentViewModel.resetImage()
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .font(.title)
                                                .foregroundStyle(Color.primary, .regularMaterial)
                                                .offset(x: 25, y: 5)
                                        }
                                        .accessibilityElement()
                                        .accessibilityIdentifier("ClearImageButton")
                                        
                                        CropperView(selectedImage: $parentViewModel.selectedImage)
                                    }
                                }
                            }
                        }
                    
                    if parentViewModel.validationInProgress {
                        ProgressView()
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
                }
                .accessibilityIdentifier("ErrorDetectedAlert")
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
    AuthenticatedView()
}

 
