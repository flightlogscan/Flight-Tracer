import SwiftUI

struct ImagePlaceholderView: View {
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
                    .padding(.bottom)
                
                Text("No Photo Selected")
                    .bold()
                    .foregroundColor(.primary)
                    .padding([.top, .bottom])
                
                Text("A preview of the photo you select will appear here.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Spacer()
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 25)
                   .fill(.ultraThinMaterial)
                    .padding([.leading, .trailing])
            }
        }
    }
}

#Preview {
    AuthenticatedView()
}

