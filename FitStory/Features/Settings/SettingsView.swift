import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var showLogoutConfirmation = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Account")) {
                    Button(action: {
                        showLogoutConfirmation = true
                    }) {
                        Text("Log Out")
                            .foregroundColor(.red)
                    }
                    .alert("Are you sure you want to log out?", isPresented: $showLogoutConfirmation) {
                        Button("Log Out", role: .destructive) {
                            authManager.signOut()
                        }
                        Button("Cancel", role: .cancel) {}
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AuthManager())
}
