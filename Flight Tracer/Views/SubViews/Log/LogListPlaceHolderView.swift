import SwiftUI

struct LogListPlaceHolderView: View {
    
    @Binding var showScanSheet: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "doc.viewfinder")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
                .padding(.bottom)

            Text("No Scans")
                .font(.title2)
                .bold()
                .foregroundColor(.primary)
                .padding(.bottom)


            Text("Your saved scans will appear here.")
                .font(.headline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding([.leading, .trailing, .bottom])
            
            Button {
                showScanSheet = true
            } label: {
                Text("Scan Log")
                    .font(.headline)
                    .padding()
                    .padding(.horizontal)
                    .foregroundColor(.black)
                    .background(.white)
                    .clipShape(Capsule())
            }
            .padding(.top)
            
            Spacer()
            Spacer()
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.white.opacity(0.5), lineWidth: 0.25)
                )
                .safeAreaPadding(.all)
                .padding(.bottom)
                .padding(.bottom)
        )
    }
}

#Preview {
    LogListPlaceHolderView(showScanSheet: .constant(true))
}
