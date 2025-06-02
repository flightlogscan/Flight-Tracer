import SwiftUI

struct ImageHintsView: View {
    
    @Binding var showHintsSheet: Bool
    
    var body: some View {
        VStack (spacing: 0) {
            ZStack {
                Text("Image Guidelines")
                    .font(.title3)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(height: 44)
            .padding([.horizontal])
            .padding(.top, 8)

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
            
            Spacer()
            
            VStack {
                Button("Continue", action: {
                    withAnimation {
                        showHintsSheet = false
                    }
                })
                .fontWeight(.semibold)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .foregroundColor(.black)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            }
            .padding()
            .padding([.leading, .trailing])
        }
    }
}

#Preview {
    ImageHintsView(showHintsSheet: .constant(true))
}
