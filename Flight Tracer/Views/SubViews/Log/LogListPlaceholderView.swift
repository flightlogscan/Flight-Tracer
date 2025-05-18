import SwiftUI

struct LogListPlaceholderView: View {
    var body: some View {
        VStack {
            VStack {
                Image(systemName: "doc.viewfinder")
                    .font(.largeTitle.weight(.medium))
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 10)

                Text("No Scans")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.top, 1)

                Text("Your saved scans will appear here.")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 2)
            }
            .frame(maxWidth: .infinity)
            .padding([.top, .bottom])
            .background {
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(.ultraThinMaterial)
            }
            .padding([.top, .leading, .trailing])
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    LogListPlaceholderView()
}
