import SwiftUI
import _PhotosUI_SwiftUI

struct ImagePresentationView: View {
    
    @State var isValidated: Bool?
    @State var showAlert = false
    @Binding var selectedImage: ImageDetail
    @ObservedObject var selectImageViewModel = SelectImageViewModel()
    
    var body: some View {
        if selectedImage.image != nil {
            VStack {
                if (isValidated == nil || !isValidated!) {
                    ZStack {
                        // Invisible rectangle underneath photo to keep spacing
                        Rectangle()
                            .foregroundColor(.clear)
                            .padding([.leading, .trailing])
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
                        
                        selectedImage.image!
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding([.leading, .trailing])
                            .overlay(
                                Button {
                                    selectedImage = ImageDetail()
                                }
                                label: {
                                    Label("", systemImage: "xmark.circle.fill")
                                        .foregroundStyle(.white, .black.opacity(0.7))
                                        .font(.title)
                                        .offset(x: -15, y: 5)
                                },
                                alignment: .topTrailing
                            )
                        
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
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding([.leading, .trailing])
                            .overlay(
                                Button {
                                    selectedImage = ImageDetail()
                                } label: {
                                    Label("", systemImage: "xmark.circle.fill")
                                        .foregroundStyle(.white, .black.opacity(0.7))
                                        .font(.title)
                                        .offset(x: -15, y: 5)
                                },
                                alignment: .topTrailing
                            )
                            .overlay(
                                Group {
                                    if selectedImage.validationResult != nil {
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
                        Text(selectedImage.validationResult?.rawValue ?? "")
                            .foregroundColor(Color.secondary)
                    }
                }
            }
            .onAppear {
                if (isValidated != true) {
                    validateImage()
                }
            }
            .onReceive(selectedImage.$isImageValid) {_ in
                 if (selectedImage.isImageValid != nil) {
                     if (selectedImage.isValidated == true && selectedImage.validationResult != nil &&
                         selectedImage.validationResult == ErrorCode.TRANSIENT_FAILURE) {
                         isValidated = nil // Reset to force refresh of the view
                     }
                     if (selectedImage.isValidated == true && selectedImage.isImageValid == false){
                         showAlert = true
                     }
                     isValidated = true
                }
                else {
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
                    .foregroundColor(.black.opacity(0.7))
            }
        }
    }
    
    func validateImage() {
        isValidated = false
        selectedImage.isValidated = false
        Task {
            selectImageViewModel.simpleValidateImage(image: selectedImage)
            selectedImage.isValidated = true
            isValidated = true
        }
    }
}

#Preview {
    UploadPageView(user: Binding.constant(nil))
}
