import SwiftUI

struct ImageHintsView: View {
    
    @Binding var showHintsSheet: Bool
    
    var body: some View {
        NavigationStack {
            List {
                Section ("What Works") {
                    HStack {
                        Image(systemName: "checkmark").foregroundColor(Color.green).fontWeight(.bold)
                        Text("File size should be 4MB or less")
                    }
                    HStack {
                        Image(systemName: "checkmark").foregroundColor(Color.green).fontWeight(.bold)
                        Text("Works best with Jeppesen logbooks")
                    }
                    HStack {
                        Image(systemName: "checkmark").foregroundColor(Color.green).fontWeight(.bold)
                        Text("Neat, bold, legible handwriting")
                    }
                    HStack {
                        Image(systemName: "checkmark").foregroundColor(Color.green).fontWeight(.bold)
                        Text("Includes both pages of the log")
                    }
                    HStack {
                        Image(systemName: "checkmark").foregroundColor(Color.green).fontWeight(.bold)
                        Text("Bright, even lighting")
                    }
                }
                Section ("Avoid These") {
                    HStack {
                        Image(systemName: "xmark").foregroundColor(Color.red).fontWeight(.bold)
                        Text("Anything that isn’t a flight log")
                    }
                    HStack {
                        Image(systemName: "xmark").foregroundColor(Color.red).fontWeight(.bold)
                        Text("Torn, wrinkled, or damaged pages")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Image Guidelines")
                        .font(.title3)
                        .fontWeight(.medium)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", systemImage: "checkmark") {
                        withAnimation {
                            showHintsSheet = false
                        }
                    }
                    .tint(.white)
                }
            }
        }
    }
}

#Preview {
    ImageHintsView(showHintsSheet: .constant(true))
}
