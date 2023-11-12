import SwiftUI

struct ScannedFlightLogsView: View {
  
    var inputArray: [[String]]
    @State var tableArray: [[String]] = [[]]
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            if (!tableArray.isEmpty) {
                LogTableView(imageText: $tableArray)
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
                DownloadView(data: tableArray)
            }
        })
        .toolbarBackground(
            Color.white,
            for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .tint(.black.opacity(0.7))
        .onAppear {
            loadData()
        }
    }
      
    // Add data detected by azure into a fixed size array for ui purposes
    func loadData() {
        let targetRowCount = 131
        let targetColumnCount = 25

        var newArray: [[String]] = Array(repeating: Array(repeating: "", count: targetColumnCount), count: targetRowCount)

        for i in 0..<min(inputArray.count, targetRowCount) {
            for j in 0..<min(inputArray[i].count, targetColumnCount) {
                newArray[i][j] = inputArray[i][j]
            }
        }

        tableArray = newArray
    }
}


