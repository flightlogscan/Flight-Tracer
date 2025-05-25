//import SwiftUI
//import FirebasePerformance
//
//struct ExportButtonView: View {
//    @ObservedObject var logSwiperViewModel: LogSwiperViewModel
//    @EnvironmentObject var storeKitManager: StoreKitManager
//    @Binding var showStore: Bool
//
//    var body: some View {
//        Group {
//            if storeKitManager.isSubscribed() {
//                ShareLink(
//                    item: logSwiperViewModel.exportURL ?? URL(string: "about:blank")!,
//                    preview: SharePreview(
//                        "flight_log.csv",
//                        image: Image("logoicon")
//                    )
//                ) {
//                    Text("Export")
//                        .font(.headline)
//                        .padding(.horizontal, 15)
//                        .padding(.vertical, 7.5)
//                        .foregroundColor(.black)
//                        .background(.thickMaterial)
//                        .environment(\.colorScheme, .light)
//                        .clipShape(Capsule())
//                }
//                .accessibilityIdentifier("ExportButton")
//                .disabled(logSwiperViewModel.exportURL == nil)
//            } else {
//                Button {
//                    showStore = true
//                } label: {
//                    Text("Export")
//                        .font(.headline)
//                        .padding(.horizontal, 15)
//                        .padding(.vertical, 7.5)
//                        .foregroundColor(.black)
//                        .background(.thinMaterial)
//                        .environment(\.colorScheme, .light)
//                        .clipShape(Capsule())
//                }
//                .accessibilityIdentifier("UnsubscribedExportButton")
//            }
//        }
//    }
//}
