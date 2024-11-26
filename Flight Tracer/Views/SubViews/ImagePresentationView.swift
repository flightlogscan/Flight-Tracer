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
                                    Button {
                                        parentViewModel.showAlert = true
                                    } label: {
                                        Label("", systemImage: "exclamationmark.circle.fill")
                                            .foregroundStyle(.white, .red)
                                            .font(.title)
                                            .offset(x: 25, y: 5)
                                    }
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
                // Runs when selected image changes
                .onReceive(parentViewModel.$selectedImage) { _ in
                    Task {
                        if (parentViewModel.selectedImage.isImageLoaded) {
                            await parentViewModel.simpleValidateImage()
                        }
                    }
                }
                // Runs when dismissed back to this view from another view
                .onDisappear() {
                    parentViewModel.resetImage()
                }
            }
        } else {
            ZStack {
                Rectangle()
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding([.leading, .trailing])
                    .shadow(radius: 5)
                
                Text("Please select a photo")
                    .font(.title3)
                    .foregroundColor(.semiTransparentBlack)
            }
        }
    }
}

#Preview {
    UploadPageView()
}
