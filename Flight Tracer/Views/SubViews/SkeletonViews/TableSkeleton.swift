import SwiftUI

struct TableSkeleton: View {
    let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 5)
    @State private var isLoading = true

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all) // Fill the entire screen with white background
            VStack(spacing: 10) { // Adjust spacing between rows
                ForEach(0..<10) { _ in
                    HStack(spacing: 10) { // Adjust spacing between columns
                        ForEach(0..<5) { _ in
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.gray.opacity(0.5))
                                .frame(width: 80, height: 30)
                                .opacity(isLoading ? 0 : 1) // Hide the skeleton when loading finishes
                        }
                    }
                    .padding(.horizontal, 10)
                    .opacity(isLoading ? 0 : 1) // Hide the skeleton when loading finishes
                }
            }
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding()
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 0.5).repeatForever()) {
                    isLoading.toggle() // Toggle loading to trigger animation
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .edgesIgnoringSafeArea(.all) // Ensure that the ZStack fills the screen
    }
}
