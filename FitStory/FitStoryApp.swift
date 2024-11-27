import SwiftUI
import AuthenticationServices

@main
struct FitStoryApp: App {
    @StateObject private var authManager = AuthManager()

    var body: some Scene {
        WindowGroup {
            if authManager.isAuthenticated {
                MainTabView() // Main app interface
            } else {
                OnboardingView(authManager: authManager)
            }
        }
    }
}
