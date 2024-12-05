import SwiftUI
import SwiftData

@main
struct FitStoryApp: App {
    @StateObject private var authManager = AuthManager()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authManager)
        }
        .modelContainer(for: [MeasurementModel.self])
    }
}
