import SwiftUI
import _PhotosUI_SwiftUI

struct ImagePresentationView: View {
    
    @State var isValidated: Bool?
    @State var validationInProgress = false
    @State var showAlert = false
    @Binding var selectedImage: ImageDetail
    @ObservedObject var simpleImageValidator = SimpleImageValidator()
    
    var body: some View {
        if selectedImage.isImageLoaded {
            VStack {
                if (validationInProgress) {
                    ZStack {
                        // Invisible rectangle underneath photo to keep spacing
                        Rectangle()
                            .foregroundColor(.clear)
                            .padding([.leading, .trailing])
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
                        
                        selectedImage.image!
                            .logImageStyle()
                        
                        ProgressView()
                            .foregroundColor(.white)
                            .tint(.white)
                            .padding()
                            .background(.black)
                            .cornerRadius(10)
                            .zIndex(1)
                    }
                }
                else {
                    ZStack {
                        // Invisible rectangle underneath photo to keep spacing
                        Rectangle()
                            .foregroundColor(.clear)
                            .padding([.leading, .trailing])
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
                        
                        selectedImage.image!
                            .logImageStyle()
                            .overlay(
                                Button {
                                    selectedImage = ImageDetail()
                                } label: {
                                    Label("", systemImage: "xmark.circle.fill")
                                        .foregroundStyle(.white, .black.opacity(0.7))
                                        .font(.title)
                                        .offset(x: -15, y: 5)
                                }
                                .accessibilityElement()
                                .accessibilityIdentifier("ClearImageButton"),
                                alignment: .topTrailing
                            )
                            .overlay(
                                Group {
                                    if selectedImage.hasError {
                                        Button {
                                            showAlert = true
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
                    }
                    .alert("Error detected:", isPresented: $showAlert) {
                        Button ("Close") {
                        }
                    } message: {
                        Text(selectedImage.validationError.message)
                            .foregroundColor(Color.secondary)
                    }
                }
            }
            .onReceive(selectedImage.$hasValidationRun) {_ in
                if (selectedImage.hasValidationRun && !selectedImage.isImageValid) {
                     showAlert = true
                     validationInProgress = false
                }
                else if (!selectedImage.hasValidationRun && selectedImage.isImageLoaded){
                    validationInProgress = true
                    validateImage()
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
    
    func validateImage() {
        Task {
            simpleImageValidator.simpleValidateImage(image: selectedImage)
            validationInProgress = false
        }
    }
}

#Preview {
    UploadPageView()
}
