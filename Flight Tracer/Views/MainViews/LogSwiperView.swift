import SwiftUI

struct LogSwiperView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authManager: AuthManager
    
    @State var showAlert = false
    @State var isDataLoaded: Bool = false
    @ObservedObject var logSwiperViewModel = LogSwiperViewModel()
    
    let uiImage: UIImage
    let selectedScanType: ScanType
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .fill(Color(.systemGray6))
                    .edgesIgnoringSafeArea(.all)
                
                if isDataLoaded {
                    Logs(logSwiperViewModel: logSwiperViewModel)
                } else {
                    ProgressView()
                        .tint(.white)
                        .padding()
                        .background(.black)
                        .cornerRadius(10)
                        .zIndex(1)
                }
            }
            .accessibilityIdentifier("LogSwiperView")
            .toolbar(content: {
                ToolbarItem (placement: .topBarLeading) {
                    Button {
                        showAlert = true
                    } label: {
                        Label("", systemImage: "xmark")
                    }
                    .accessibilityIdentifier("xmark")
                    .alert("Delete Log?", isPresented: $showAlert) {
                        Button("Cancel", role: .cancel) {}
                        Button("Delete", role: .destructive) {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    } message: {
                        Text("Deleting this log will delete its data, but any data stored in iCloud will not be deleted.")
                    }
                }
                
                ToolbarItem (placement: .topBarTrailing) {
                    DownloadView(rowViewModels: logSwiperViewModel.rowViewModels)
                        .accessibilityIdentifier("DownloadView")
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
            .alert("Error detected:", isPresented: $logSwiperViewModel.showAlert) {
                Button("Back") {
                    // Navigate back to the main view if there are errors
                    self.presentationMode.wrappedValue.dismiss()
                }
            } message: {
                Text(logSwiperViewModel.alertMessage)
                    .foregroundColor(Color.secondary)
            }
            .onAppear {
                logSwiperViewModel.scanImageForLogText(uiImage: uiImage, userToken: authManager.user.token, selectedScanType: selectedScanType)
            }
            .onReceive(logSwiperViewModel.$rowViewModels) { _ in
                Task {
                    if !logSwiperViewModel.rowViewModels.isEmpty {
                        isDataLoaded = true
                    }
                }
            }
        }
    }
}

struct Logs: View {
    @ObservedObject var logSwiperViewModel: LogSwiperViewModel

    var body: some View {
        TabView {
            if logSwiperViewModel.rowViewModels.count > 0 {
                ForEach(logSwiperViewModel.rowViewModels.indices, id: \.self) { rowIndex in
                    LogTab(rowViewModel: logSwiperViewModel.rowViewModels[rowIndex])
                }
            } else {
                ProgressView()
                    .foregroundColor(.white)
                    .tint(.white)
                    .padding()
                    .background(.black)
                    .cornerRadius(10)
                    .zIndex(1)
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

struct LogTab: View {
    @ObservedObject var rowViewModel: LogRowViewModel
    let logFieldMetadata = LogMetadataLoader.getLogMetadata(named: "JeppesenLogFormat")
    
    var flattenedMetadata: [LogFieldMetadata] {
        logFieldMetadata.flatMap { Array(repeating: $0, count: $0.columnCount) }
    }
        
    var body: some View {
        List {
            ForEach(0..<flattenedMetadata.count, id: \.self) { cellIndex in
                HStack {
                    Text(flattenedMetadata[cellIndex].fieldName)
                        .bold()
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if cellIndex < rowViewModel.fields.count {
                        TextField("", text: $rowViewModel.fields[cellIndex])
                            .font(.system(size: 14))
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    } else {
                        Text("Error: more fields detected than log fields")
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
}
