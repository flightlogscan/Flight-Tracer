import SwiftUI
import FirebasePerformance

struct ExportButtonView: View {
    @ObservedObject var logSwiperViewModel: LogSwiperViewModel
    @EnvironmentObject var storeKitManager: StoreKitManager
    @Binding var showStore: Bool
    
    var body: some View {
        Group {
            if storeKitManager.isPremium() {
                Button {
                    print("Export button tapped")
                } label: {
                    ShareLink(
                        item: generateCSVURL(),
                        preview: SharePreview(
                            "flight_log.csv",
                            image: Image("logoicon")
                        )
                    ) {
                        Text("Export")
                            .font(.headline)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 7.5)
                            .foregroundColor(.black)
                            .background(.thinMaterial)
                            .environment(\.colorScheme, .light)
                            .clipShape(Capsule())
                    }
                }
                .accessibilityIdentifier("ExportButton")
                .id(logSwiperViewModel.editCounter) // Force refresh when edits are made
            } else {
                Button {
                    showStore = true
                } label: {
                    Text("Export")
                        .font(.headline)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 7.5)
                        .foregroundColor(.black)
                        .background(.thinMaterial)
                        .environment(\.colorScheme, .light)
                        .clipShape(Capsule())
                }
                .accessibilityIdentifier("UnsubscribedExportButton")
            }
        }
    }
    
    private func generateCSVURL() -> URL {
        print("generateCSVURL called in ExportButtonView")
        if let editableData = logSwiperViewModel.editableLogData {
            print("When generating URL - Content edits count: \(editableData.contentEdits.count)")
            print("When generating URL - Header edits count: \(editableData.headerEdits.count)")
        }
        // This will generate a fresh URL with the latest edits
        return logSwiperViewModel.convertLogRowsToCSV()
    }
}
