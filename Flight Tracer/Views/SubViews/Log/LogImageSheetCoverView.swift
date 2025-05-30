import SwiftUI
import UIKit

struct LogImageSheetCoverView: View {
    let imageData: Data?
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.navyBlue, .black, .black]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .ignoresSafeArea(.all)
                    .accessibilityIdentifier("ScanBackground")

                if let data = imageData,
                   let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .logImageStyle()
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    DismissScreenCoverButton()
                }
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

#Preview {
    ScansView()
}
