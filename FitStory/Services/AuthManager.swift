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
            if let userID = try keychainService.read(AuthManager.appleUserIdKey) {
                validateCredentialState(for: userID)
            } else {
                isAuthenticated = false
            }
        } catch {
            print("Error reading credentials: \(error.localizedDescription)")
            isAuthenticated = false
        }
    }
    
    func validateCredentialState(for userID: String) {
        ASAuthorizationAppleIDProvider().getCredentialState(forUserID: userID) { [weak self] state, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("[AuthManager] Credential State request returned with error: \(error.localizedDescription)")

                    // Handle specific Apple Sign-In error codes
                    if (error as NSError).code == -7084 {
                        print("[AuthManager] Ignoring -7084 error during development.")
                        self?.isAuthenticated = true // Treat as authenticated in development
                        return
                    }

                    // Fallback: Treat as not authenticated for other errors
                    self?.handleRevokedState(for: userID)
                    return
                }

                switch state {
                case .authorized:
                    print("[AuthManager] Credential state is authorized.")
                    self?.isAuthenticated = true
                case .revoked:
                    print("[AuthManager] Credential state is revoked. Prompting user to reauthenticate.")
                    self?.handleRevokedState(for: userID)
                case .notFound:
                    print("[AuthManager] Credential state not found. Prompting user to reauthenticate.")
                    self?.handleRevokedState(for: userID)
                default:
                    print("[AuthManager] Credential state is unknown: \(state).")
                    break
                }
            }
        }
    }
    
    private func handleRevokedState(for userID: String) {
        // Optionally clear Keychain data if you suspect it’s stale
        do {
            try keychainService.delete(AuthManager.appleUserIdKey)
            try keychainService.delete(AuthManager.identityTokenKey)
            print("[AuthManager] Cleared outdated Keychain data.")
        } catch {
            print("[AuthManager] Failed to clear Keychain data: \(error.localizedDescription)")
        }

        // Update the authentication state
        isAuthenticated = false

        // Notify the user (optional)
        DispatchQueue.main.async {
            // Add code to show a reauthentication prompt
            print("[AuthManager] User needs to reauthenticate.")
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
}
