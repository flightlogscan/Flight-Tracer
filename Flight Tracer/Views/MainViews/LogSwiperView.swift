import SwiftUI

struct LogSwiperView: View {
    @State var showAlert = false
    @Environment(\.presentationMode) var presentationMode
    @State var isDataLoaded: Bool = false
    @ObservedObject var logSwiperViewModel = LogSwiperViewModel()
    @Binding var selectedImage: ImageDetail
    var selectedScanType: Int
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .fill(Color(.systemGray6))
                    .edgesIgnoringSafeArea(.all)
                
                if isDataLoaded {
                    Logs(imageText: $selectedImage.recognizedText)
                } else {
                    ProgressView()
                        .tint(.white)
                        .padding()
                        .background(.black)
                        .cornerRadius(10)
                        .zIndex(1)
                }
            }
            .toolbar(content: {
                ToolbarItem (placement: .topBarLeading){
                    Button {
                        showAlert = true
                        
                    } label: {
                        Label("", systemImage: "xmark")
                    }
                    .alert("Delete Log?", isPresented: $showAlert) {
                        Button ("Cancel", role: .cancel) {
                        }
                        
                        Button("Delete", role: .destructive) {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    } message: {
                        Text("Deleting this log will delete its data, but any data stored in iCloud will not be deleted.")
                    }
                }
                
                ToolbarItem (placement: .topBarTrailing) {
                    DownloadView(data: selectedImage.recognizedText)
                }
            })
            .tint(.white)
            .toolbarBackground(
                Color(red: 0.0, green: 0.2, blue: 0.5),
                for: .navigationBar
            )
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbarBackground(.visible, for: .navigationBar)
            .onAppear {
                logSwiperViewModel.processImageText(selectedImage: selectedImage, userToken: authViewModel.user.token, selectedScanType: selectedScanType)
            }
            .onReceive(selectedImage.$analyzeResult) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if selectedImage.analyzeResult != nil {
                        print("image text loaded count \(selectedImage.recognizedText.count)")
                        isDataLoaded = true
                    } else if selectedImage.isImageValid == false {
                        // Navigate back to the main view if there are errors
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct Logs: View {
    @Binding var imageText: [[String]]

    var body: some View {
        TabView {
            let _ = print("imagetext rows: \($imageText.count)")
            
            if ($imageText.count < 3) {
                Text("yikes not enough rows")
            }
            
            // Skip first 2 rows because of headers
            ForEach(3..<imageText.count, id: \.self) { rowIndex in
                if !isRowEmpty(imageText[rowIndex]) {
                    LogTab(row: $imageText[rowIndex])
                }
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
    
    private func isRowEmpty(_ row: [String]) -> Bool {
        return row.allSatisfy { $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }
}

struct LogTab: View {
    @Binding var row: [String]
    let logFieldMetadata = LogMetadataLoader.getLogMetadata(named: "JeppesenLogFormat")
        
    var body: some View {
        List {
            ForEach(0..<logFieldMetadata.count, id: \.self) { cellIndex in
                HStack {
                    Text(logFieldMetadata[cellIndex].fieldName)
                        .bold()
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if cellIndex < row.count {
                        // Bind the TextField to the original row value
                        TextField("", text: Binding(
                            get: {
                                return row[cellIndex]
                            },
                            set: { newValue in
                                row[cellIndex] = newValue
                            }
                        ))
                        .font(.system(size: 14))
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    } else {
                        Text(">")
                    }
                }
            }
        }
    }
}
