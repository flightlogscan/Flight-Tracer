import SwiftUI

struct LogSwiperView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext

    @EnvironmentObject var authManager: AuthManager
    
    @State var isDataLoaded: Bool = false
    @StateObject var logSwiperViewModel = LogSwiperViewModel()
        
    @Binding var showScanSheet: Bool
        
    //TODO: Needs to be optional/error handled if non-existant
    @State var editableLog: EditableLog = EditableLog(editableRows: [])

    let uiImage: UIImage
    let selectedScanType: ScanType
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [.navyBlue, .black, .black]),
                    startPoint: .top,
                    endPoint: .bottom
                ))
                .edgesIgnoringSafeArea(.all)
                .accessibilityIdentifier("LogSwiperBackground")
            
            NavigationStack {
                ZStack {
                    if isDataLoaded {
                        LogTabsView(editableLog: $editableLog)
                    } else {
                        SparklesProgressView()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        if isDataLoaded {
                            DiscardScanButtonView()
                        } else {
                            // Reserves space for toolbox so the sparkles progress view doesn't bounce
                            Color.clear.frame(width: 44, height: 44)
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        if isDataLoaded {
                            SaveLogButtonView(
                                userId: authManager.user.id,
                                modelContext: modelContext,
                                editableLog: editableLog,
                                logSaveMode: .new
                            ) {
                                showScanSheet = false
                            }
                        } else {
                            // Reserves space for toolbox so the sparkles progress view doesn't bounce
                            Color.clear.frame(width: 44, height: 44)
                        }
                    }
                }
                .toolbarBackground(.hidden, for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden()
                .alert("Error detected:", isPresented: $logSwiperViewModel.showAlert) {
                    Button("Back") {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                } message: {
                    Text(logSwiperViewModel.alertMessage)
                }
                .onAppear {
                    logSwiperViewModel.scanImageForLogText(
                        uiImage: uiImage,
                        userToken: authManager.user.token,
                        selectedScanType: selectedScanType
                    )
                }
                .onReceive(logSwiperViewModel.$editableLog) { log in
                    if let log = log {
                        editableLog = log
                        isDataLoaded = !log.editableRows.isEmpty
                    }
                }
            }
        }
        .background(Color.clear)
    }
}
