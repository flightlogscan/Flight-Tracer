import SwiftUI

struct ScannedFlightLogsView: View {
  
    @State private var tableArray: [[String]] = [[]]
    var inputArray: [[String]]
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            if (!tableArray.isEmpty) {
                TableView(imageText: $tableArray)
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

struct TableView: View {
    @Binding var imageText: [[String]]
    let frameWidth: CGFloat = 75
    let frameHeight: CGFloat = 25

    var body: some View {
        if (!$imageText.isEmpty) {
            ScrollView([.horizontal, .vertical], showsIndicators: true) {
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    Section(header: HeaderRowView(imageText: $imageText)) {
                        ForEach(1..<$imageText.count, id: \.self) { row in                             
                            LazyHStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                                Section (header: RowNumberView(index: row)) {
                                    ForEach(0..<$imageText[row].count, id: \.self) { col in
                                        TextField("Enter text", text: $imageText[row][col])
                                            .textFieldStyle(TableTextFieldStyle())
                                            .opacity(1.0)
                                            .frame(width: frameWidth, height: frameHeight)
                                            .background(Color.clear)
                                            .border(Color.gray, width: 0.3)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                UIScrollView.appearance().bounces = false
            }
        }
    }
}

struct RowNumberView: View {
    let index: Int
    
    var body: some View {
        Text(index == 0 ? "" : "\(index)")
            .font(.system(size: 11, weight: .regular, design: .default))
            .opacity(0.8)
            .frame(width: 50, height: 25)
            .background(Color(.systemGray5))
            .border(Color.gray, width: 0.3)
            .zIndex(1)
    }
}

struct HeaderRowView: View {
    @Binding var imageText: [[String]]
    
    var body: some View {
        LazyHStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
            Section(header: CornerCell()) {
                let firstRow: Binding<[String]> = $imageText[0]
                
                ForEach(0..<firstRow.count, id: \.self) { index in
                    TextField("Enter text", text: firstRow[index])
                        .textFieldStyle(TableTextFieldStyle())
                        .opacity(0.8)
                        .frame(width: 75, height: 25)
                        .background(Color(.systemGray5))
                        .border(Color.gray, width: 0.3)
                }
            }
        }
    }
}

struct CornerCell: View {
    var body: some View {
        Text("")
            .font(.system(size: 11, weight: .regular, design: .default))
            .frame(width: 50, height: 25)
            .background(Color(.systemGray5))
            .border(Color.gray, width: 0.3)
    }
}

struct ExperimentalTable_Previews: PreviewProvider {
    static var previews: some View {
        Emptytest()
    }
}
