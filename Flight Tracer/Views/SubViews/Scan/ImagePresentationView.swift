import SwiftUI
import _PhotosUI_SwiftUI

struct ImagePresentationView: View {
    
    @ObservedObject var parentViewModel: ScanViewModel
    @Binding var activeScanPressed: Bool
    @Binding var showStore: Bool
    
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
                            if (!parentViewModel.selectedImage.hasError && !parentViewModel.validationInProgress) {
                                ScanButtonView(scanPressed: $activeScanPressed)
                            }
                        }
                        .overlay(alignment: .topLeading) {
                            ImageTopLeftControls(parentViewModel: parentViewModel)
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

 
