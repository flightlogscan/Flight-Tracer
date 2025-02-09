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
                    // TODO: Re-enable download view
//                    DownloadView(rows: logSwiperViewModel.rows)
//                        .accessibilityIdentifier("DownloadView")
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
    
    // Group rows by rowIndex
    var groupedRows: [Int: [RowDTO]] {
        Dictionary(grouping: logSwiperViewModel.rows.filter { !$0.header }) { $0.rowIndex }
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
    
    // Combine content from all rows
    var combinedContent: [String: String] {
        var combined: [String: String] = [:]
        for row in rows {
            combined.merge(row.content) { current, _ in current }
        }
        return combined
    }
    
    // Define field mappings (we'll only show fields that have data)
    private let fieldNames: [String: String] = [
        "0": "DATE",
        "1": "AIRCRAFT TYPE",
        "2": "AIRCRAFT IDENT",
        "3": "FROM",
        "4": "TO",
        "5": "NR INST. APP",
        "6": "REMARKS AND ENDORSEMENTS",
        "7": "NR T/O",
        "8": "NR LDG",
        "9": "SINGLE-ENGINE LAND",
        "10": "SINGLE-ENGINE LAND (NIGHT)",
        "11": "MULTI-ENGINE LAND",
        "12": "MULTI-ENGINE LAND (NIGHT)",
        "13": "INT APR",
        "14": "INT APR (CONT)",
        "15": "INST APR",
        "16": "INST APR (CONT)",
        "17": "NIGHT",
        "18": "NIGHT (CONT)",
        "19": "ACTUAL INSTRUMENT",
        "20": "ACTUAL INSTRUMENT (CONT)",
        "21": "SIMULATED INSTRUMENT",
        "22": "SIMULATED INSTRUMENT (CONT)",
        "23": "FLIGHT SIMULATOR",
        "24": "FLIGHT SIMULATOR (CONT)",
        "25": "CROSS COUNTRY",
        "26": "CROSS COUNTRY (CONT)",
        "27": "AS FLIGHT INSTRUCTOR",
        "28": "AS FLIGHT INSTRUCTOR (CONT)",
        "29": "DUAL RECEIVED",
        "30": "DUAL RECEIVED (CONT)",
        "31": "PILOT IN COMMAND",
        "32": "PILOT IN COMMAND (CONT)",
        "33": "TOTAL DURATION",
        "34": "TOTAL DURATION (CONT)"
    ]
    
    var body: some View {
        List {
            ForEach(Array(combinedContent.sorted { $0.key < $1.key }), id: \.key) { key, value in
                if let fieldName = fieldNames[key] {
                    HStack {
                        Text(fieldName)
                            .bold()
                            .font(.system(size: 14))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(value)
                            .font(.system(size: 14))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
            }
        }
    }
}
