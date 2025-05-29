import SwiftUI

struct LogSwiperView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext

    @EnvironmentObject var authManager: AuthManager
    
    @State var isDataLoaded: Bool = false
    @State var showStore: Bool = false
    @StateObject var logSwiperViewModel = LogSwiperViewModel()
    
    @State var editableRows: [EditableRow] = []
    
    @Binding var showScanSheet: Bool
        
    let uiImage: UIImage
    let selectedScanType: ScanType
    
    var body: some View {
        ZStack {
            if (showStore) {
                Color.semiTransparentBlack
                    .ignoresSafeArea(.all)
                    .zIndex(2)
            }
            
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
                        LogTabsView(editableRows: $editableRows)
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
                .toolbar {
                    if !showStore && isDataLoaded {
                        ToolbarItem(placement: .topBarLeading) {
                            DeleteLogButtonView()
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            SaveLogButtonView(
                                userId: authManager.user.id,
                                modelContext: modelContext,
                                editableRows: editableRows,
                                logSaveMode: .new
                            ) {
                                showScanSheet = false
                            }
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
                .onReceive(logSwiperViewModel.$rows) { rows in
                    editableRows = rows
                    isDataLoaded = !rows.isEmpty
                }
            }
        }
        .background(Color.clear)
        .premiumSheet(isPresented: $showStore) {
            FLSStoreView()
        }
    }
}
