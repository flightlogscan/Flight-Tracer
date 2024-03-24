import SwiftUI
import _PhotosUI_SwiftUI

struct ImagePresentationView: View {
    
    @State var isValidated: Bool?
    @Binding var selectedImage: ImageDetail
    @Binding var selectedItem: PhotosPickerItem?
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
                                    selectedItem = nil
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
                            .tint(.white)
                            .padding()
                            .background(.black)
                            .cornerRadius(10)
                            .zIndex(1)
                    }
                    Text("Validating...")
                        .foregroundColor(Color.gray)
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
                                    selectedItem = nil
                                } label: {
                                    Label("", systemImage: "xmark.circle.fill")
                                        .foregroundStyle(.white, .black.opacity(0.7))
                                        .font(.title)
                                        .offset(x: -15, y: 5)
                                },
                                alignment: .topTrailing
                            )
                    }
                }
                if (selectedImage.isValidated! && selectedImage.isImageValid == false) {
                    Text("Invalid flight log. Please try a new image.")
                        .foregroundColor(Color.red)
                    if (selectedImage.validationResult != nil) {
                        Text(selectedImage.validationResult!)
                            .foregroundColor(Color.secondary)
                    }
                } else if (selectedImage.isValidated! && selectedImage.isImageValid == true) {
                    // TODO: This green is ugly af plz pick a better shade of green
                    Text("Validated image successfully, ready for scan.")
                        .foregroundColor(Color.green)
                }
            }
        
            .onAppear {
                if (isValidated != true) {
                    validateImage()
                }
            }
            .onReceive(selectedImage.$isImageValid) {_ in
                if (selectedImage.isImageValid != nil) {
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
        isValidated = nil
        Task {
            selectImageViewModel.simpleValidateImage(image: selectedImage)
        }
    }
}

#Preview {
    UploadPageView(user: Binding.constant(nil))
}
