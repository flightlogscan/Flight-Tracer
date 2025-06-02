import SwiftUI

struct ImagePlaceholderView: View {
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "photo")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
                .padding(.bottom)
            
            Text("No Photo Selected")
                .font(.title3)
                .bold()
                .foregroundColor(.primary)
                .padding([.top, .bottom])
            
            Text("A preview of the photo you select will appear here.")
                .font(.headline.weight(.medium))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.horizontal)
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
    ImagePlaceholderView()
}
