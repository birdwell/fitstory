import SwiftUI

@main
struct FitStoryApp: App {
    @StateObject private var authManager = AuthManager()

    var body: some Scene {
        WindowGroup {
            if authManager.isAuthenticated {
                MainTabView()
            } else {
                OnboardingView(authManager: authManager)
            }
        }
    }
}
