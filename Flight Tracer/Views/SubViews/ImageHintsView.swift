import SwiftUI

struct ImageHintsView: View {
    
    var body: some View {
        VStack (alignment: .leading, spacing: 5){
            HStack {
                Image(systemName: "checkmark").foregroundColor(Color.green).fontWeight(.bold)
                Text("Readable, neat, and bold handwritten text")
            }
            HStack {
                Image(systemName: "checkmark").foregroundColor(Color.green).fontWeight(.bold)
                Text("Includes both pages of the log")
            }
            HStack {
                Image(systemName: "checkmark").foregroundColor(Color.green).fontWeight(.bold)
                Text("Well-lit images")
            }
            HStack {
                Image(systemName: "xmark").foregroundColor(Color.red).fontWeight(.bold)
                Text("Images that are not flight logs")
            }
            HStack {
                Image(systemName: "xmark").foregroundColor(Color.red).fontWeight(.bold)
                Text("Wrinkles or tears in the log")
            }
            Text("File size should be 10MB or less")
                .font(.subheadline)
                .padding([.top])
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.leading, .top])      
    }
}
