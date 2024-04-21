import SwiftUI

struct RadioButtonAPIView: View {
    @Binding var selectedOption: Int // 0: Real API call, 1: Localhost call, 2: Hardcoded data call
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            RadioButtonField(id: 0, label: "Localhost call", isSelected: selectedOption == 0, callback: radioButtonSelected)
            RadioButtonField(id: 1, label: "Real API call", isSelected: selectedOption == 1, callback: radioButtonSelected)
            RadioButtonField(id: 2, label: "Hardcoded data call", isSelected: selectedOption == 2, callback: radioButtonSelected)
            
            //Text("Selected option: \(selectedOption)")
        }
    }
    
    func radioButtonSelected(id: Int) {
        selectedOption = id
    }
}

struct RadioButtonField: View {
    let id: Int
    let label: String
    let isSelected: Bool
    let callback: (Int) -> Void
    
    var body: some View {
        Button(action: {
            callback(id)
        }) {
            HStack {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle").foregroundColor(.black)
                Text(label).foregroundColor(.black).font(.system(size: 12)) // Set font size
            }
        }
    }
}
