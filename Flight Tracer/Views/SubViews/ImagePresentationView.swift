import SwiftUI
import _PhotosUI_SwiftUI

struct ImagePresentationView: View {
    
    @State var isValidated: Bool?
    @Binding var selectedImages: [ImageDetail]
    @Binding var selectedItem: PhotosPickerItem?
    @ObservedObject var selectImageViewModel = SelectImageViewModel()
    
    var body: some View {
        if selectedImages.count > 0 {
                VStack {
                    if (isValidated == nil || !isValidated!) {
                        ZStack {
                            // Invisible rectangle underneath photo to keep spacing
                            Rectangle()
                                .foregroundColor(.clear)
                                .padding([.leading, .trailing])
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
                            
                            ForEach(selectedImages) {image in
                                selectedImages[0].image
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .padding([.leading, .trailing])
                                    .overlay(
                                        Button {
                                            if let idx = selectedImages.firstIndex(of: selectedImages[0]) {
                                                selectedImages.remove(at: idx)
                                                selectedItem = nil
                                            }
                                        } label: {
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
                        }
                    } else {
                        ZStack {
                            // Invisible rectangle underneath photo to keep spacing
                            Rectangle()
                                .foregroundColor(.clear)
                                .padding([.leading, .trailing])
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
                            
                            ForEach(selectedImages) {image in
                                selectedImages[0].image
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .padding([.leading, .trailing])
                                    .overlay(
                                        Button {
                                            if let idx = selectedImages.firstIndex(of: selectedImages[0]) {
                                                selectedImages.remove(at: idx)
                                                selectedItem = nil
                                            }
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
                        if (selectedImages[0].isValidated && selectedImages[0].isImageValid != true) {
                            Text("Invalid flight log. Please try a new image.")
                                .foregroundColor(Color.red)
                        }
                    }
                }
                .onAppear {
                    validateImage()
                }
                .onReceive(selectedImages[0].$isImageValid) {_ in
                    if (selectedImages[0].isImageValid != nil) {
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
        Task {
            selectImageViewModel.simpleValidateImage(image: selectedImages[0])
        }
    }
}

#Preview {
    FlightLogUploadView(user: Binding.constant(nil))
}
