import SwiftUI

struct ExperimentalTable: View {
  
    @State var form: RecognizedForm?
    @State var isDataLoaded: Bool?
    @ObservedObject var contentViewModel = ContentViewModel()
    @State var images: [ImageDetail] = []
    @State var scanTypeSelected: Bool = false
    @Binding var user: User?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            if (isDataLoaded == nil || !isDataLoaded!){
                Color(uiColor: Colors.NAVY_BLUE)
                    .ignoresSafeArea()
                Image(systemName: "airplane")
                    .resizable()
                    .frame(width: 150, height: 150, alignment: .center)
                    .foregroundColor(Color(uiColor: Colors.GOLD))
            } else if (isDataLoaded!) {
                if let form = form {
                    TableView(table: images[0].analyzeResult!.tables[0])
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
        .onReceive(images[0].$analyzeResult) {_ in
            if (images[0].analyzeResult != nil) {
                isDataLoaded = true
            }
        }
    }
      
    func loadJSON() {
        isDataLoaded = false
        contentViewModel.processImageText(images: images, realScan: true, user: user)
        form = RecognizedForm(analyzeResult: images[0].analyzeResult)
    }
}

struct TableView: View {
    let table: Table
    let frameWidth: CGFloat = 75
    let frameHeight: CGFloat = 25

    var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: true) {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                Section(header: ColHeaderView(table: table)) {
                    ForEach(1..<131, id: \.self) { row in                             LazyHStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                            Section (header: RowHeaderView(index: row)) {
                                ForEach(0..<table.columnCount, id: \.self) { col in
                                    Text(getCellData(row: row, col: col))
                                        .font(.system(size: 11, weight: .regular, design: .default))
                                        .opacity(1.0)
                                        .frame(width: frameWidth, height: frameHeight, alignment: .center)
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
  
  func getCellData(row: Int, col: Int) -> String {
      return table.cells.first(where: {
          $0.rowIndex == row && $0.columnIndex == col
      })?.content ?? ""
  }
}

struct RowHeaderView: View {
    let index: Int
    
    var body: some View {
        Text(index == 0 ? "" : "\(index)")
            .font(.system(size: 11, weight: .regular, design: .default))
            .opacity(0.8)
            .frame(width: 50, height: 25, alignment: .center)
            .background(Color(.systemGray5))
            .border(Color.gray, width: 0.3)
            .zIndex(1)
    }
}

struct ColHeaderView: View {
    let table: Table
    
    var body: some View {
        
        LazyHStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
            Section(header: CornerCell()) {
                ForEach(getHeaderRow(from: table)) { cellData in
                    Text(cellData.string)
                        .font(.system(size: 11, weight: .regular, design: .default))
                        .opacity(0.8)
                        .frame(width: 75, height: 25, alignment: .center)
                        .background(Color(.systemGray5))
                        .border(Color.gray, width: 0.3)
                }
            }
        }
    }
    
    func getHeaderRow(from table: Table) -> [CellValue] {
        return (0..<table.columnCount).map { colIndex in
            
            let content = table.cells.first {
                $0.rowIndex == 0 && $0.columnIndex == colIndex
            }?.content
            
            return CellValue(content ?? "")
        }
    }
}

//Cell values can be identical so need to give unique id for ForEach loop
struct CellValue: Identifiable {
    let id = UUID()
    let string: String

    init(_ string: String) {
        self.string = string
    }
}

struct CornerCell: View {
    var body: some View {
        Text("")
            .font(.system(size: 11, weight: .regular, design: .default))
            .frame(width: 50, height: 25, alignment: .center)
            .background(Color(.systemGray5))
            .border(Color.gray, width: 0.3)
    }
}

struct ExperimentalTable_Previews: PreviewProvider {
    static var previews: some View {
        Emptytest()
    }
}
