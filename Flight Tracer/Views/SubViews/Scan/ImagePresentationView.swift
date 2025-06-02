import SwiftUI
import _PhotosUI_SwiftUI

struct ImagePresentationView: View {
    
    @ObservedObject var parentViewModel: ScanViewModel
    @Binding var showStore: Bool
    
    var body: some View {
        VStack {
            HStack {
                CameraView(selectedImage: $parentViewModel.selectedImage)
                PhotoPickerView(selectedImage: $parentViewModel.selectedImage)
            }
            .padding(.top)
            
            if parentViewModel.selectedImage.isImageLoaded {
                Spacer()
                VStack {
                    ZStack {
                        parentViewModel.selectedImage.image!
                            .logImageStyle()
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
                    .onReceive(parentViewModel.$selectedImage) { _ in
                        Task {
                            if (parentViewModel.selectedImage.isImageLoaded) {
                                await parentViewModel.simpleValidateImage()
                            }
                        }
                    }
                }
                Spacer()
                Spacer()

            } else {
                Spacer()
                ImagePlaceholderView()
            }
        }
    }
}

#Preview {
    ScansView()
}

 
