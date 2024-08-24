//
//  LogSwiperView.swift
//  Flight Tracer
//
//  Created by Wilbur 😎 on 8/4/24.
//

import SwiftUI

var headers: [JsonLoader.Field] {
       if let stringArray = JsonLoader.loadJSONFromFile(named: "JeppesenLogFormat") {
           print("Loaded strings: \(stringArray)")
           return stringArray
       } else {
           print("Failed to load strings.")
           return []
       }
   }

var expandedHeaders = expandHeaders(headers)

struct LogSwiperView: View {
    @State var tempdata = [[""]]
    @State var showAlert = false
    @Environment(\.presentationMode) var presentationMode
    @State var isDataLoaded: Bool? = nil
    @ObservedObject var contentViewModel = ContentViewModel()
    @State var selectedImage: ImageDetail
    @State var selectedScanType: Int
    @State var scanTypeSelected: Bool = false
    @Binding var user: User?
    @State var imageText: [[String]] = [[]]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .fill(Color(.systemGray6))
                    .edgesIgnoringSafeArea(.all)
                
                if isDataLoaded != nil && isDataLoaded == true {
                    Logs(imageText: $imageText)

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
                    .alert("Are you sure?", isPresented: $showAlert) {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Yes - delete my scan")
                                .foregroundStyle(.red)
                        }
                        
                        Button ("No - keep my scan") {
                        }
                    } message: {
                        Text("You will lose the log data from this scan.")
                    }
                }
                
                ToolbarItem (placement: .topBarTrailing) {
                    DownloadView(data: $tempdata)
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
                loadJSON()
            }
            .onReceive(selectedImage.$analyzeResult) {_ in
                if (selectedImage.analyzeResult != nil) {
                    imageText = convertTo2DArray(analyzeResult: selectedImage.analyzeResult!, headers: headers)
                    let _ = print("image text loaded count \(imageText.count)")
                    isDataLoaded = true
                }
            }
        }
    }
    
    func loadJSON() {
        isDataLoaded = false
        contentViewModel.processImageText(selectedImage: selectedImage, realScan: true, user: user, selectedScanType: selectedScanType)
    }
    
    func convertTo2DArray(analyzeResult: AnalyzeResult, headers: [JsonLoader.Field]) -> [[String]] {
        // Calculate total number of columns from headers
        let columnCount = headers.reduce(0) { $0 + $1.columnCount }
        
        // Get the first and third tables, if available
        let tables = analyzeResult.tables.indices.contains(2) ? [analyzeResult.tables[0], analyzeResult.tables[2]] : [analyzeResult.tables[0]]
        
        // Find the maximum row count across the selected tables
        let maxRowCount = tables.reduce(0) { max($0, $1.rowCount) }
        
        // Initialize the result array
        var resultArray = Array(repeating: Array(repeating: "", count: columnCount), count: maxRowCount + 1)
        
        // Initialize column offset to track column positions across the selected tables
        var columnOffset = 0
        
        // Iterate through the selected tables and merge rows
        for table in tables {
            for cell in table.cells {
                let rowIndex = cell.rowIndex + 1
                let columnIndex = columnOffset + cell.columnIndex
                
                // Ensure indices are within bounds
                if rowIndex < resultArray.count && columnIndex < resultArray[rowIndex].count {
                    resultArray[rowIndex][columnIndex] = cell.content
                }
            }
            columnOffset += table.columnCount
        }
        
        return resultArray
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
            // Skip first 2 rows cause of headers
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
        
    var body: some View {
        List {

            ForEach(0..<expandedHeaders.count, id: \.self) { cellIndex in
                HStack {
                    Text(expandedHeaders[cellIndex])
                        .bold()
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if cellIndex < $row.count {
                        TextField("", text: $row[cellIndex])
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

func expandHeaders(_ headers: [JsonLoader.Field]) -> [String] {
    var result: [String] = []
    
    for field in headers {
        result.append(contentsOf: Array(repeating: field.fieldName, count: field.columnCount))
    }
    
    return result
}
