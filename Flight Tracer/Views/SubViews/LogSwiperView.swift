//
//  LogSwiperView.swift
//  Flight Tracer
//
//  Created by Wilbur 😎 on 8/4/24.
//

import SwiftUI

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
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .fill(Color(.systemGray6))
                    .edgesIgnoringSafeArea(.all)
                
                if isDataLoaded != nil && isDataLoaded == true {
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
                    let _ = print("image text loaded count \(selectedImage.recognizedText.count)")
                    isDataLoaded = true
                } else if (selectedImage.isImageValid == false) {
                    // Navigate back to the main view if there are errors
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    func loadJSON() {
        isDataLoaded = false
        contentViewModel.processImageText(selectedImage: selectedImage, realScan: true, user: user, selectedScanType: selectedScanType)
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
        
    var body: some View {
        List {
            ForEach(0..<expandedHeaders.count, id: \.self) { cellIndex in
                HStack {
                    Text(expandedHeaders[cellIndex].value)
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
                                // Update the original row value
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
