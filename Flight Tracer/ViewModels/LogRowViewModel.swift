import SwiftUI
class LogRowViewModel: ObservableObject, Identifiable {
    @Published var fields: [String]
    
    init(fields: [String]) {
        self.fields = fields
    }
}
