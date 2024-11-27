import SwiftUI
import AuthenticationServices

struct SignInWithAppleButtonView: View {
    @ObservedObject var authManager: AuthManager

    var body: some View {
        SignInWithAppleButton(
            .signIn,
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                switch result {
                case .success(let authorization):
                    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
                       let identityToken = appleIDCredential.identityToken,
                       let tokenString = String(data: identityToken, encoding: .utf8) {
                        authManager.signIn(with: appleIDCredential.user, identityToken: tokenString)
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
