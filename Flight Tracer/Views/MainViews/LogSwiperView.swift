//
//  LogSwiperView.swift
//  Flight Tracer
//

import SwiftUI

struct LogSwiperView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authManager: AuthManager
    
    @State var showAlert = false
    @State var isDataLoaded: Bool = false
    @StateObject var logSwiperViewModel = LogSwiperViewModel()
    
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
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
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
                
                ToolbarItem(placement: .topBarTrailing) {
                    DownloadView(logSwiperViewModel: logSwiperViewModel)
                        .accessibilityIdentifier("DownloadView")
                }
            }
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
                    self.presentationMode.wrappedValue.dismiss()
                }
            } message: {
                Text(logSwiperViewModel.alertMessage)
                    .foregroundColor(Color.secondary)
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
    let rows: [RowDTO]
    
    // Get field names from the header row
    var fieldNames: [String: String] {
        let headerRow = rows.first(where: { $0.header })
        return headerRow?.content ?? [:]
    }
    
    // Get content from non-header rows by combining them
    var rowContent: [String: String] {
        var combined: [String: String] = [:]
        // Merge content from all non-header rows with the same rowIndex
        rows.filter({ !$0.header }).forEach { row in
            combined.merge(row.content) { current, _ in current }
        }
        return combined
    }
    
    var body: some View {
        List {
            ForEach(Array(fieldNames.sorted { Int($0.key) ?? 0 < Int($1.key) ?? 0 }), id: \.key) { key, fieldName in
                HStack {
                    Text(fieldName)
                        .bold()
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(rowContent[key] ?? "")
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
        }
        .onAppear {
            print("Field names:", fieldNames)
            print("Row content:", rowContent)
        }
    }
}
