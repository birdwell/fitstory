import SwiftUI
import AuthenticationServices

struct OnboardingView: View {
    @ObservedObject var authManager: AuthManager

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to FitStory")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()

            Text("Your journey to wellness starts here.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            SignInWithAppleButtonView(authManager: authManager)
                .frame(height: 50) // Set button height
                .padding(.horizontal, 40) // Add padding for width alignment

            Spacer()
        }
        .padding()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(authManager: AuthManager())
    }
}
