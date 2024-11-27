import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var authManager: AuthManager

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

            SignInWithAppleButtonView()
                .frame(height: 50)
                .padding(.horizontal, 40)

            Spacer()
        }
        .padding()
    }
}
