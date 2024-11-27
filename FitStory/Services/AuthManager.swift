import Foundation

class AuthManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    
    static let key = "fitstory.appleUserID"

    init() {
        checkAuthentication()
    }

    func checkAuthentication() {
        if let _ = KeychainService.shared.read(AuthManager.key) {
            isAuthenticated = true
        } else {
            isAuthenticated = false
        }
    }

    func signIn(with userID: String) {
        KeychainService.shared.save(userID, for: AuthManager.key)
        isAuthenticated = true
    }

    func signOut() {
        KeychainService.shared.delete(AuthManager.key)
        isAuthenticated = false
    }
}
