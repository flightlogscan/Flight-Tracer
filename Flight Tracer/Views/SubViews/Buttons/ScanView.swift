import SwiftUI

struct ScanView: View {

    @State var buttonActive: Bool = false
    @Binding var allowScan: Bool
    @Binding var selectedImage: ImageDetail
    @Binding var user: User?
    @ObservedObject var contentViewModel = ContentViewModel()
    
    var body: some View {
        VStack{
            
            Button {
                allowScan = buttonActive
            } label: {
                Label("Scan photo", systemImage: "doc.viewfinder.fill")
                    .frame(maxWidth: .infinity)
                    .font(.title2)
                    .padding()
            }
            .onAppear() {
                buttonActive = (selectedImage.isImageValid == true && selectedImage.isValidated == true)
            }
            .buttonStyle(.borderedProminent)
            .tint(buttonActive ? .green : .gray.opacity(0.5))
            .shadow(color: buttonActive ? .gray : .clear, radius: buttonActive ? 5 : 0)
            .bold()
            .padding([.leading, .trailing, .bottom])
        }
        .onReceive(selectedImage.$isImageValid) {_ in
            if (selectedImage.isImageValid != nil) {
                print(selectedImage.isImageValid)
                buttonActive = selectedImage.isImageValid! && selectedImage.isValidated == true
            } else {
                buttonActive = false
            }
        }
    }
}

#Preview {
    UploadPageView(user: Binding.constant(nil))
}
