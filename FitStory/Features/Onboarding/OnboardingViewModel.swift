import Combine
import SwiftUI

class OnboardingViewModel: ObservableObject {
    @Published var isNotificationsEnabled: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    func toggleNotifications() {
        NotificationService.requestPermission { [weak self] granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    self?.isNotificationsEnabled = granted
                }
            }
        }
    }
}
