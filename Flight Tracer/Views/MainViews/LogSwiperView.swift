import SwiftUI

struct LogSwiperView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State var showAlert = false
    @State var isDataLoaded: Bool = false
    @ObservedObject var viewModel = LogSwiperViewModel()
    
    let uiImage: UIImage
    let selectedScanType: ScanType
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .fill(Color(.systemGray6))
                    .edgesIgnoringSafeArea(.all)
                
                if isDataLoaded {
                    Logs(logText: $viewModel.logText)
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
                    DownloadView(data: viewModel.logText)
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
            .alert("Error detected:", isPresented: $viewModel.showAlert) {
                Button ("Back") {
                    // Navigate back to the main view if there are errors
                    self.presentationMode.wrappedValue.dismiss()
                }
            } message: {
                Text(viewModel.alertMessage)
                    .foregroundColor(Color.secondary)
            }
            .onAppear {
                viewModel.scanImageForLogText(uiImage: uiImage, userToken: authViewModel.user.token, selectedScanType: selectedScanType)
            }
            .onReceive(viewModel.$logText) { _ in
                Task {
                    if !viewModel.logText.isEmpty {
                        print("image text loaded count \($viewModel.logText.count)")
                        print("logText:")
                        for (rowIndex, row) in viewModel.logText.enumerated() {
                            print("Row \(rowIndex): \(row)")
                        }
                        isDataLoaded = true
                    }
                }
            }
        }
    }
}

struct Logs: View {
    @Binding var logText: [[String]]

    var body: some View {
        TabView {
            if ($logText.count > 2) {
                // Skip first 2 rows because of headers
                ForEach(3..<logText.count, id: \.self) { rowIndex in
                    if !isRowEmpty(logText[rowIndex]) {
                        LogTab(row: $logText[rowIndex])
                    }
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
                        // TODO: Refactor
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
                        Text("Error: more field detected than log fields")
                    }
                }
            }
        }
    }
}
