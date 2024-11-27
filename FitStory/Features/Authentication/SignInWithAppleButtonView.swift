import SwiftUI
import AuthenticationServices

struct SignInWithAppleButtonView: View {
    @ObservedObject var authManager: AuthManager

    var body: some View {
        SignInWithAppleButton(
            .signIn,
            onRequest: { request in
                // Configure request
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                switch result {
                case .success(let authorization):
                    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                        let userID = appleIDCredential.user
                        authManager.signIn(with: userID)
                    }
                case .failure(let error):
                    print("Sign in with Apple failed: \(error.localizedDescription)")
                }
            }
        )
        .signInWithAppleButtonStyle(.black)
        .cornerRadius(10)
    }
}

#Preview {
    SignInWithAppleButtonView(authManager: AuthManager())
}
