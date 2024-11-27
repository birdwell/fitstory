import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Adjust your preferences.")
                .font(.title)
                .padding()
            Text("This is the Settings screen.")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
