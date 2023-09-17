// SwiftUI View
import SwiftUI

struct ExperimentalTable: View {
  
  @State private var form: RecognizedForm?
  
  var body: some View {
    VStack {
      if let form = form {
        TableView(table: form.analyzeResult.tables[0])
      }
    }
    .onAppear {
      loadJSON()
    }
  }
  
  func loadJSON() {
    let url = Bundle.main.url(forResource: "custom-layout", withExtension: "json")!
    let data = try! Data(contentsOf: url)
    form = try! JSONDecoder().decode(RecognizedForm.self, from: data)
  }
}

struct TableView: View {
  let table: Table
    let frameWidth: CGFloat = 75
    let frameHeight: CGFloat = 20
    @State private var text: String = "initial"


  
  var body: some View {
      ScrollView(.horizontal, showsIndicators: false) {
          ScrollView(.vertical, showsIndicators: false) {
              LazyVStack(spacing: 0) {
                  ForEach(0..<table.rowCount, id: \.self) { row in
                      LazyHStack(spacing: 0) {
                          ForEach(0..<table.columnCount, id: \.self) { col in
                              Text(getCell(row: row, col: col))
                                  .font(.system(size: 11, weight: .regular, design: .default))
                                  .opacity(row == 0 ? 0.7 : 1.0)
                                  .frame(width: frameWidth, height: frameHeight, alignment: .center)
                                  .background(row == 0 ? Color.gray.opacity(0.2) : Color.clear)
                                  .border(Color.gray, width: 0.3)
                          }
                      }
                  }
              }
          }
      }
  }
  
  func getCell(row: Int, col: Int) -> String {
    return table.cells.first(where: { $0.rowIndex == row && $0.columnIndex == col })?.content ?? ""
  }
}

struct RecognizedForm: Codable {
  let analyzeResult: AnalyzeResult
}

struct AnalyzeResult: Codable {
    let content: String
    let tables: [Table]
    let documents: [Document]
}

struct Document: Codable {
    
}


struct Table: Codable {
    let rowCount: Int
    let columnCount: Int
    let cells: [Cell]
}

struct Cell: Codable {
    let rowIndex: Int
    let columnIndex: Int
    let content: String
}


struct ExperimentalTable_Previews: PreviewProvider {
    static var previews: some View {
        ExperimentalTable()
    }
}
