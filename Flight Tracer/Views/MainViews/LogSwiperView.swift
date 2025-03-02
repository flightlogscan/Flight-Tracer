import SwiftUI

struct LogSwiperView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authManager: AuthManager
    
    @State var isDataLoaded: Bool = false
    @StateObject var logSwiperViewModel = LogSwiperViewModel()
    
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
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        DeleteLogButtonView()
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        ExportButtonView(logSwiperViewModel: logSwiperViewModel)
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
                    isDataLoaded = !rows.isEmpty
                }
            }
        }
        .background(Color.clear)
    }
}

struct Logs: View {
    @ObservedObject var logSwiperViewModel: LogSwiperViewModel
    
    // Group all rows by rowIndex, including header
    var groupedRows: [Int: [RowDTO]] {
        let headerRow = logSwiperViewModel.rows.first(where: { $0.header })
        let dataRows = Dictionary(grouping: logSwiperViewModel.rows.filter { !$0.header }) { $0.rowIndex }
        
        // Add header row to each group
        var result: [Int: [RowDTO]] = [:]
        for (index, rows) in dataRows {
            if let header = headerRow {
                result[index] = [header] + rows
            } else {
                result[index] = rows
            }
        }
        return result
    }

    var body: some View {
        TabView {
            if !groupedRows.isEmpty {
                ForEach(Array(groupedRows.keys).sorted(), id: \.self) { rowIndex in
                    if let rows = groupedRows[rowIndex] {
                        LogTab(rows: rows)
                    }
                }
            } else {
                ProgressView()
                    .foregroundColor(.white)
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
    let rows: [RowDTO]
    
    // Get field names from the header row
    var fieldNames: [String: String] {
        let headerRow = rows.first(where: { $0.header })?.content ?? [:]
        return headerRow
    }
    
    // Get content from non-header rows by combining them
    var rowContent: [String: String] {
        var combined: [String: String] = [:]
        rows.filter({ !$0.header }).forEach { row in
            combined.merge(row.content) { current, _ in current }
        }
        return combined
    }
    
    var body: some View {
        List {
            ForEach(Array(fieldNames.keys.sorted { (Int($0) ?? 0) < (Int($1) ?? 0) }), id: \.self) { key in
                HStack {
                    Text(fieldNames[key] ?? "")
                        .bold()
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(rowContent[key] ?? "")
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
        }
        .scrollContentBackground(.hidden)
    }
}
