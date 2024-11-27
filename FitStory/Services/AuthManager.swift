import Foundation
import AuthenticationServices

class AuthManager: ObservableObject {
    @Published var isAuthenticated: Bool = false

    static let appleUserIdKey = "fitstory.appleUserID"
    static let identityTokenKey = "fitstory.identityToken"
    
    private let keychainService = KeychainService.shared

    init() {
        checkAuthentication()
    }

    func checkAuthentication() {
        do {
            if let _ = try keychainService.read(AuthManager.appleUserIdKey) {
                validateCredentialState()
            } else {
                isAuthenticated = false
            }
        } catch {
            print("Error checking authentication: \(error.localizedDescription)")
            isAuthenticated = false
        }
    }

    func signIn(with userID: String, identityToken: String) {
        do {
            // Store the Apple User ID and token in Keychain
            try keychainService.save(userID, for: AuthManager.appleUserIdKey)
            try keychainService.save(identityToken, for: AuthManager.identityTokenKey)
            isAuthenticated = true
        } catch {
            print("Error signing in: \(error.localizedDescription)")
            isAuthenticated = false
        }
    }

    func signOut() {
        do {
            // Remove user data from Keychain
            try keychainService.delete(AuthManager.appleUserIdKey)
            try keychainService.delete(AuthManager.identityTokenKey)
            isAuthenticated = false
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }

    private func validateCredentialState() {
        guard let storedUserID = try? keychainService.read(AuthManager.appleUserIdKey) else {
            isAuthenticated = false
            return
        }

        ASAuthorizationAppleIDProvider().getCredentialState(forUserID: storedUserID) { [weak self] state, _ in
            DispatchQueue.main.async {
                switch state {
                case .authorized:
                    self?.isAuthenticated = true
                case .revoked, .notFound:
                    self?.signOut()
                default:
                    break
                }
            }
        }
    }
}
