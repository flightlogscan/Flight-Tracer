import SwiftUI

struct TablePageView: View {
    
    @State var isDataLoaded: Bool?
    @ObservedObject var contentViewModel = ContentViewModel()
    @State var selectedImage: ImageDetail
    @State var scanTypeSelected: Bool = false
    @Binding var user: User?
    @Environment(\.presentationMode) var presentationMode
    @State var imageText: [[String]] = [[]]
    
    var body: some View {
        ZStack {
            if (isDataLoaded == nil || !isDataLoaded!){
                ProgressView()
                    .tint(.white)
                    .padding()
                    .background(.black)
                    .cornerRadius(10)
                    .zIndex(1)
                
                //LogTableView(imageText: $imageText)
                //need skeleton log table here
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
                Button {
                    //TODO: Download data here.
                } label: {
                    Label("", systemImage: "square.and.arrow.down")
                        .font(.title)
                }
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
            }
        }
    }
    
    func loadJSON() {
        isDataLoaded = false
        contentViewModel.processImageText(selectedImage: selectedImage, realScan: true, user: user)
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
