import SwiftUI

struct TablePageView: View {
    
    @State var isDataLoaded: Bool?
    @ObservedObject var contentViewModel = ContentViewModel()
    @State var selectedImage: ImageDetail
    @State var selectedScanType: Int
    @State var scanTypeSelected: Bool = false
    @Binding var user: User?
    @Environment(\.presentationMode) var presentationMode
    @State var imageText: [[String]] = [[]]
    
    var body: some View {
        ZStack {
            if (isDataLoaded == nil || !isDataLoaded!){
                // TODO: Show the bullet points with the skeleton loader
                // TODO: Update the styling of the skeleton loader to more closely match our actual table
                TableSkeleton()
            } else if (isDataLoaded!) {
                VStack{
                    ResultsInstructionsView()
                    LogTableView(imageText: $imageText)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar(content: {
            ToolbarItem (placement: .topBarLeading){
                Button(action : { self.presentationMode.wrappedValue.dismiss() }){
                    Label("", systemImage: "chevron.left")
                }
            }
            
            ToolbarItem (placement: .topBarTrailing) {
                DownloadView(data: $imageText)
            }
        })
        .toolbarBackground(
            Color.white,
            for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .tint(.black.opacity(0.7))
        .onAppear {
            loadJSON()
        }
        .onReceive(selectedImage.$analyzeResult) {_ in
            if (selectedImage.analyzeResult != nil) {
                isDataLoaded = true
                imageText = convertTo2DArray(analyzeResult: selectedImage.analyzeResult!)
            } else if (selectedImage.isImageValid == false) {
                // Navigate back to the main view if there are errors
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    func loadJSON() {
        isDataLoaded = false
        contentViewModel.processImageText(selectedImage: selectedImage, realScan: true, user: user, selectedScanType: selectedScanType)
    }
    
    func convertTo2DArray(analyzeResult: AnalyzeResult) -> [[String]] {
        guard let table = analyzeResult.tables.first else {
            return [[]]
        }
        
        var resultArray = Array(repeating: Array(repeating: "", count: table.columnCount), count: table.rowCount)
        
        for cell in table.cells {
            resultArray[cell.rowIndex][cell.columnIndex] = cell.content
        }
        
        return resultArray
    }
}
