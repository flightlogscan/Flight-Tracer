import Foundation

@MainActor
class DeleteAccountViewModel: ObservableObject {
    @Published var deletionStatus: DeletionStatus?
    
    let fltDeleteAccount = FLTDeleteAccount()

    enum DeletionStatus {
        case success
        case failure
    }

    func deleteAccount(token: String, selectedScanType: ScanType) async {
        let result = await fltDeleteAccount.deleteAccount(withToken: token, selectedScanType: selectedScanType)
        switch result {
        case .success:
            deletionStatus = .success
        default:
            deletionStatus = .failure
        }
    }
}
